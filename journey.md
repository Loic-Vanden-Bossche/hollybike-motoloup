# Journey Processing Algorithm (Technical / Mathematical Specification)

This document specifies the journey reconstruction algorithm implemented in:
- `packages/backend/src/main/kotlin/hollybike/api/utils/EkfJourney.kt`
- `packages/backend/src/main/kotlin/hollybike/api/utils/AccelPreprocess.kt`
- `packages/backend/src/main/kotlin/hollybike/api/services/UserEventPositionService.kt`

It describes the exact model, update equations, numerical choices, and derived metrics used by the backend.

## 1. End-to-End Pipeline

Given a time-ordered sequence of raw telemetry samples for one user/event:

1. Build `PositionSample` values:
- timestamp `t_k` (ms)
- latitude/longitude `(lat_k, lon_k)`
- altitude `alt_k`
- horizontal accuracy `acc_k` (m)
- optional speed `vGps_k` (m/s)
- optional accelerometer `(a_x, a_y, a_z)` (m/s²)

2. Build EKF-only samples `EkfPositionSample`:
- `(t_k, lat_k, lon_k, acc_k, vGps_k)`

3. Run `EkfJourney.smoothTrajectory(...)`:
- local tangent-plane projection
- forward EKF pass with robust gating
- RTS backward smoother
- output smoothed state sequence \(\hat x_k^s\)

4. Run `AccelPreprocess.computeLinearAccelMetrics(...)`:
- gravity estimate + removal
- low-pass on linear acceleration magnitude
- jerk

5. Build GeoJSON and journey KPIs:
- smoothed coordinates
- speed series (sensor speed when valid, otherwise EKF speed norm)
- elevation gain/loss
- average/max speed
- average/max g-force
- max jerk

## 2. Coordinate Model

A local equirectangular tangent-plane approximation is used with origin at first sample:

- \(\phi_0 = \text{rad}(lat_0)\)
- \(\lambda_0 = \text{rad}(lon_0)\)
- \(R = 6,371,000\,m\)

Forward map (lat/lon to XY):

\[
x = (\lambda - \lambda_0)\cos(\phi_0)R,
\quad
y = (\phi - \phi_0)R
\]

Inverse map:

\[
\phi = \frac{y}{R} + \phi_0,
\quad
\lambda = \frac{x}{R\cos(\phi_0)} + \lambda_0
\]

with degrees/radians conversion at API boundaries.

## 3. Dynamic State and Process Model

State vector (constant-velocity in 2D):

\[
\mathbf{x}_k =
\begin{bmatrix}
x_k \\
y_k \\
v_{x,k} \\
v_{y,k}
\end{bmatrix}
\in \mathbb{R}^4
\]

Sampling interval:

\[
\Delta t_k =
\begin{cases}
0 & k=0 \\
\max(0, t_k - t_{k-1})/1000 & k>0
\end{cases}
\]

(so non-increasing timestamps produce \(\Delta t_k=0\), no artificial positive minimum step).

State transition matrix:

\[
\mathbf{F}_k =
\begin{bmatrix}
1 & 0 & \Delta t_k & 0 \\
0 & 1 & 0 & \Delta t_k \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
\]

Process noise uses white acceleration (CV model) with \(\sigma_a = 2.0\,m/s^2\):

\[
\mathbf{Q}_k = \sigma_a^2
\begin{bmatrix}
\frac{\Delta t^4}{4} & 0 & \frac{\Delta t^3}{2} & 0 \\
0 & \frac{\Delta t^4}{4} & 0 & \frac{\Delta t^3}{2} \\
\frac{\Delta t^3}{2} & 0 & \Delta t^2 & 0 \\
0 & \frac{\Delta t^3}{2} & 0 & \Delta t^2
\end{bmatrix}
\]

Prediction step:

\[
\hat{\mathbf{x}}_k^- = \mathbf{F}_k\hat{\mathbf{x}}_{k-1}
\]
\[
\mathbf{P}_k^- = \mathbf{F}_k\mathbf{P}_{k-1}\mathbf{F}_k^T + \mathbf{Q}_k
\]

Initial conditions:
- \(\hat{\mathbf{x}}_0=[x_0,y_0,0,0]^T\)
- \(\mathbf{P}_0=\operatorname{diag}(25,25,100,100)\)

## 4. Measurement Model (EKF)

Position is always measured; speed is optionally measured.

### 4.1 Input validation

Per sample:
- position valid iff latitude/longitude finite and within bounds
- accuracy valid iff finite (0 or negative are accepted and clamped later)
- speed used iff finite and \(\ge 0\)

If position or accuracy is invalid, measurement update is skipped for that sample:
\(\hat x_k = \hat x_k^-\), \(P_k=P_k^-\).

### 4.2 Observation function

If speed unavailable (dimension \(m=2\)):

\[
\mathbf{z}_k = [x_{gps},y_{gps}]^T,
\quad
\mathbf{h}(\mathbf{x}) = [x,y]^T
\]

If speed available (dimension \(m=3\)):

\[
\mathbf{z}_k = [x_{gps},y_{gps},v_{gps}]^T,
\quad
\mathbf{h}(\mathbf{x}) = [x,y,\sqrt{v_x^2+v_y^2}]^T
\]

Residual:

\[
\mathbf{r}_k = \mathbf{z}_k - \mathbf{h}(\hat{\mathbf{x}}_k^-)
\]

Jacobian:

\[
\mathbf{H}_k = \frac{\partial \mathbf{h}}{\partial \mathbf{x}}
\]

For \(m=2\):

\[
\mathbf{H}_k =
\begin{bmatrix}
1&0&0&0\\
0&1&0&0
\end{bmatrix}
\]

For \(m=3\), third row uses \(v=\sqrt{v_x^2+v_y^2}\), \(\epsilon=10^{-6}\), \(d=\max(\epsilon,v)\):

\[
\left[0,0,\frac{v_x}{d},\frac{v_y}{d}\right]
\]

### 4.3 Measurement covariance

Position sigma:

\[
\sigma_{pos} = \max(1.0, acc_k)
\]

So \(R_{xx}=R_{yy}=\sigma_{pos}^2\).

If speed is used, fixed speed noise:

\[
\sigma_{speed}=1.5\,m/s,
\quad
R_{vv}=\sigma_{speed}^2
\]

Hence:

\[
\mathbf{R}_k=\operatorname{diag}(\sigma_{pos}^2,\sigma_{pos}^2[,\sigma_{speed}^2])
\]

Innovation covariance:

\[
\mathbf{S}_k = \mathbf{H}_k \mathbf{P}_k^- \mathbf{H}_k^T + \mathbf{R}_k
\]

## 5. Robust Gating

Mahalanobis distance:

\[
d_k^2 = \mathbf{r}_k^T \mathbf{S}_k^{-1} \mathbf{r}_k
\]

Implementation computes this by solving:

\[
\mathbf{S}_k\mathbf{u}=\mathbf{r}_k,
\quad
d_k^2=\mathbf{r}_k^T\mathbf{u}
\]

(no explicit matrix inversion).

Gate thresholds:
- \(m=2\): \(d_k^2 > 9.21\) rejected
- \(m=3\): \(d_k^2 > 11.34\) rejected

(these are ~99% chi-square thresholds for 2 and 3 dof).

Rejected sample behavior:

\[
\hat{\mathbf{x}}_k=\hat{\mathbf{x}}_k^-,
\quad
\mathbf{P}_k=\mathbf{P}_k^-
\]

## 6. Kalman Update (Accepted Measurements)

Kalman gain is solved without explicit inverse:

\[
\mathbf{K}_k = \mathbf{P}_k^-\mathbf{H}_k^T\mathbf{S}_k^{-1}
\]

implemented as linear solve:

\[
\mathbf{S}_k\mathbf{X}=(\mathbf{P}_k^-\mathbf{H}_k^T)^T,
\quad
\mathbf{K}_k = \mathbf{X}^T
\]

State update:

\[
\hat{\mathbf{x}}_k = \hat{\mathbf{x}}_k^- + \mathbf{K}_k\mathbf{r}_k
\]

Covariance update uses Joseph stabilized form:

\[
\mathbf{P}_k = (\mathbf{I}-\mathbf{K}_k\mathbf{H}_k)\mathbf{P}_k^-(\mathbf{I}-\mathbf{K}_k\mathbf{H}_k)^T + \mathbf{K}_k\mathbf{R}_k\mathbf{K}_k^T
\]

Then explicit symmetrization to reduce floating-point asymmetry drift:

\[
\mathbf{P}_k \leftarrow \frac{1}{2}(\mathbf{P}_k + \mathbf{P}_k^T)
\]

## 7. RTS Backward Smoother

After forward pass, smoothed state list initialized with filtered states.

For \(k=N-2,\dots,0\):

Smoother gain:

\[
\mathbf{C}_k = \mathbf{P}_k\mathbf{F}_{k+1}^T(\mathbf{P}_{k+1}^-)^{-1}
\]

Implemented by linear solve (no explicit inverse):

\[
(\mathbf{P}_{k+1}^-)^T \mathbf{C}_k^T = (\mathbf{P}_k\mathbf{F}_{k+1}^T)^T
\]

State smoothing:

\[
\hat{\mathbf{x}}_k^s = \hat{\mathbf{x}}_k + \mathbf{C}_k(\hat{\mathbf{x}}_{k+1}^s - \hat{\mathbf{x}}_{k+1}^-)
\]

Covariance smoothing:

\[
\mathbf{P}_k^s = \mathbf{P}_k + \mathbf{C}_k(\mathbf{P}_{k+1}^s - \mathbf{P}_{k+1}^-)\mathbf{C}_k^T
\]

with final symmetrization:

\[
\mathbf{P}_k^s \leftarrow \frac{1}{2}(\mathbf{P}_k^s + (\mathbf{P}_k^s)^T)
\]

Output from EKF module: smoothed \((x,y,v_x,v_y)\) states and origin.

## 8. Acceleration Preprocessing (Linear Accel / g-force / Jerk)

For each `PositionSample` with valid `(ax, ay, az)`:

1. Raw acceleration vector:
\[
\mathbf{a}_{raw,k}=[a_x,a_y,a_z]^T
\]

2. Time step for accel filter:
\[
\Delta t_k =
\begin{cases}
0.02 & \text{first accel sample} \\
\max(0.005, (t_k-t_{k-1})/1000) & \text{otherwise}
\end{cases}
\]

3. Gravity low-pass estimate:
\[
\alpha_g = \frac{\tau_g}{\tau_g+\Delta t_k}, \quad \tau_g=0.8\,s
\]
\[
\hat{\mathbf{g}}_k = \alpha_g\hat{\mathbf{g}}_{k-1} + (1-\alpha_g)\mathbf{a}_{raw,k}
\]

4. Linear acceleration estimate:
\[
\mathbf{a}_{lin,k}=\mathbf{a}_{raw,k}-\hat{\mathbf{g}}_k
\]

5. Component-wise clamp (robustification):
\[
a_{lin,i} \in [-35, 35]\,m/s^2
\]

6. Magnitude:
\[
\ell_k = \|\mathbf{a}_{lin,k}\|_2
\]

7. Low-pass on magnitude:
\[
\alpha_\ell = \frac{\tau_\ell}{\tau_\ell+\Delta t_k}, \quad \tau_\ell=0.15\,s
\]
\[
\tilde \ell_k = \alpha_\ell\tilde \ell_{k-1} + (1-\alpha_\ell)\ell_k
\]

8. Derived metrics:
- g-force: \(g_k = \tilde \ell_k / 9.80665\)
- jerk: \(j_k = (\tilde \ell_k - \tilde \ell_{k-1})/\Delta t_k\) (0 for first/invalid predecessor)

If accel is missing/non-finite at index \(k\), output metric is `null` for that index.

## 9. Journey KPIs and Output Construction

For each index \(k\):

1. Convert smoothed \((x_k^s,y_k^s)\) back to \((lat_k^s, lon_k^s)\).
2. Use original altitude \(alt_k\).
3. Speed used in output:
\[
v_k =
\begin{cases}
vGps_k & \text{if finite and } vGps_k\ge 0 \\
\sqrt{(v_{x,k}^s)^2 + (v_{y,k}^s)^2} & \text{otherwise}
\end{cases}
\]

4. Elevation deltas from raw altitude:
\[
\Delta h_k = alt_k - alt_{k-1}
\]
- if \(\Delta h_k\ge 0\): add to gain
- else add \(-\Delta h_k\) to loss

Aggregates:
- `avgSpeed` = arithmetic mean of \(v_k\)
- `maxSpeed` = max of \(v_k\)
- `minElevation`, `maxElevation` from raw altitude
- `avgGForce`, `maxGForce` from non-null accel metrics
- `maxJerk` from \(|j_k|\)
- total time from first/last timestamp

GeoJSON output:
- geometry: smoothed coordinates `[lon_s, lat_s, alt_raw]`
- properties: `coordTimes[]`, `speed[]`
- bbox computed from produced geometry

## 10. Numerical Strategy and Stability Choices

1. No explicit inverses in EKF update or RTS gain.
2. Pivoted Gauss-Jordan linear solve for all small systems.
3. Joseph covariance form for EKF correction.
4. Explicit covariance symmetrization after filter and smoother updates.
5. Outlier rejection by chi-square gating.
6. Invalid measurement fallback to predict-only (instead of hard crash) for per-sample invalid lat/lon or non-finite accuracy.

## 11. Current Tunable Constants

- Earth radius: `R_EARTH = 6371000.0`
- Process acceleration sigma: `sigmaAccel = 2.0 m/s²`
- Position noise floor: `sigmaPos = max(1.0, accuracyM)`
- Speed noise sigma: `sigmaSpeed = 1.5 m/s`
- Gate thresholds: `9.21` (2D), `11.34` (3D)
- Solver singular threshold: `1e-12`
- Accel preprocess:
  - `gravityTauSeconds = 0.8`
  - `linLowPassTauSeconds = 0.15`
  - `spikeClampMS2 = 35.0`
  - gravity constant `G = 9.80665`

## 12. Complexity

Let \(N\) be sample count.

- EKF forward pass: \(\mathcal{O}(N)\) with fixed-size small matrices (constant work per sample).
- RTS backward pass: \(\mathcal{O}(N)\), constant-size operations.
- Accel preprocessing: \(\mathcal{O}(N)\).

Overall: linear in sample count, with small constant factors.

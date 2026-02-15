# Design System - Glassmorphism Modern (Catppuccin)

## Aesthetic
Apple Vision Pro / Glassmorphism aesthetic. Frosted glass surfaces, backdrop blur, soft gradient background blobs, layered translucent depth, generous rounded corners, smooth transitions.

## Reference Implementation

```tsx
import { h } from 'preact';
import {
  Users,
  Calendar,
  LayoutGrid,
  Mail,
  MoreHorizontal,
  ArrowUpRight,
  Plus,
  Search,
  Filter,
  CheckCircle2,
  Clock,
  XCircle,
} from 'lucide-preact';
import { clsx } from 'clsx';

// ============================================================
// CORE DESIGN TOKENS
// ============================================================

// Background: bg-mantle (main app bg), bg-crust (deepest layer)
// Cards/Surfaces: bg-surface-0/30 with backdrop-blur-xl + border border-surface-2/30 + rounded-3xl
// Primary action: bg-blue text-crust, shadow-lg shadow-blue/20
// Secondary action: bg-surface-0/40 backdrop-blur-md border border-surface-2/30, rounded-2xl
// Text hierarchy: text-text (primary), text-subtext-0 (secondary), text-subtext-1 (tertiary/label)
// Accent colors: text-blue, text-mauve, text-teal, text-pink, text-green, text-yellow, text-red, text-peach
// Shadows: shadow-[0_8px_32px_0_rgba(0,0,0,0.15)] for glass cards

// ============================================================
// GLASS CARD - Core surface component
// ============================================================

const GlassCard = ({ children, className, hover = false }: { children: any, className?: string, hover?: boolean }) => (
  <div className={clsx(
    "relative overflow-hidden",
    "bg-surface-0/30 backdrop-blur-xl",
    "border border-surface-2/30",
    "rounded-3xl shadow-[0_8px_32px_0_rgba(0,0,0,0.15)]",
    hover && "transition-all duration-500 hover:bg-surface-0/50 hover:border-surface-2/50 hover:-translate-y-1 hover:shadow-2xl",
    className
  )}>
    {children}
  </div>
);

// ============================================================
// STAT CARD - Metric display
// ============================================================

const StatCard = ({ title, value, icon: Icon, trend, colorClass }: { title: string, value: string, icon: any, trend: string, colorClass: string }) => (
  <GlassCard className="p-6" hover>
    <div className="flex justify-between items-start mb-4">
      <div className={clsx("p-3 rounded-2xl bg-surface-1/40 border border-surface-2/30", colorClass)}>
        <Icon size={22} />
      </div>
      <div className="flex items-center gap-1 text-[10px] font-bold px-2 py-1 rounded-full bg-surface-1/50 border border-surface-2/20 text-subtext-0">
        <ArrowUpRight size={12} className="text-green" />
        {trend}
      </div>
    </div>
    <div>
      <p className="text-subtext-1 text-sm font-medium mb-1 uppercase tracking-wider">{title}</p>
      <h3 className="text-3xl font-bold tracking-tight text-text">{value}</h3>
    </div>
  </GlassCard>
);

// ============================================================
// STATUS BADGES
// ============================================================

const StatusBadge = ({ status }: { status: 'Complété' | 'En attente' | 'Annulé' | 'Actif' }) => {
  const styles: Record<string, string> = {
    'Complété': 'bg-green/10 text-green border-green/20',
    'Actif': 'bg-green/10 text-green border-green/20',
    'En attente': 'bg-yellow/10 text-yellow border-yellow/20',
    'Annulé': 'bg-red/10 text-red border-red/20',
  };
  const Icons: Record<string, any> = { 'Complété': CheckCircle2, 'Actif': CheckCircle2, 'En attente': Clock, 'Annulé': XCircle };
  const Icon = Icons[status];
  return (
    <span className={clsx("inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold border backdrop-blur-md", styles[status])}>
      {Icon && <Icon size={14} />}
      {status}
    </span>
  );
};

// ============================================================
// BUTTONS
// ============================================================

// Primary Button (main CTA)
// className="flex items-center gap-2 px-6 py-2.5 rounded-2xl bg-blue text-crust font-bold shadow-lg shadow-blue/20 transition-all hover:brightness-110 active:scale-95"

// Secondary/Ghost Button
// className="flex items-center gap-2 px-5 py-2.5 rounded-2xl bg-surface-0/40 backdrop-blur-md border border-surface-2/30 text-text font-medium transition-all hover:bg-surface-0/60 active:scale-95"

// Danger Button
// className="flex items-center gap-2 px-5 py-2.5 rounded-2xl bg-red/10 text-red border border-red/20 font-medium transition-all hover:bg-red/20 active:scale-95"

// Pagination Button (active)
// className="px-4 py-1.5 rounded-lg bg-surface-2/40 border border-surface-2/60 text-text hover:bg-surface-2/60 transition-colors"

// Pagination Button (disabled)
// className="px-4 py-1.5 rounded-lg border border-surface-2/30 text-subtext-0 hover:bg-surface-1/50 transition-colors disabled:opacity-50"

// ============================================================
// INPUTS
// ============================================================

// Search Input with icon
// Container: "relative group"
// Icon: "absolute left-3 top-1/2 -translate-y-1/2 text-subtext-1 transition-colors group-focus-within:text-blue"
// Input: "bg-surface-1/30 border border-surface-2/30 rounded-xl py-2 pl-10 pr-4 text-sm focus:outline-none focus:ring-2 focus:ring-blue/30 focus:border-blue/50 transition-all w-64"

// Standard Input
// "bg-surface-1/30 border border-surface-2/30 rounded-xl py-2.5 px-4 text-sm focus:outline-none focus:ring-2 focus:ring-blue/30 focus:border-blue/50 transition-all w-full"

// ============================================================
// TABLE STYLES
// ============================================================

// Table container: inside a GlassCard with p-1
// Table header row: "text-subtext-1 text-xs uppercase tracking-widest border-b border-surface-1/20"
// Table header cell: "px-6 py-5 font-semibold"
// Table body row: "group transition-colors hover:bg-white/5" with "divide-y divide-surface-1/10" on tbody
// Table body cell: "px-6 py-5"
// Avatar in table: "w-10 h-10 rounded-xl bg-gradient-to-br from-blue/20 to-mauve/20 border border-surface-2/30 flex items-center justify-center text-blue font-bold"
// Table footer: "p-4 bg-surface-0/20 flex items-center justify-between text-sm border-t border-surface-1/30"

// ============================================================
// SIDEBAR
// ============================================================

// Sidebar bg: GlassCard style with "bg-surface-0/30 backdrop-blur-xl border-r border-surface-2/30"
// Nav item: "flex items-center gap-3 px-4 py-2.5 rounded-xl text-subtext-0 hover:bg-surface-0/40 hover:text-text transition-all"
// Active nav item: "bg-surface-0/50 text-text border border-surface-2/20"
// Section label: "text-[10px] font-bold uppercase tracking-[0.2em] text-subtext-1 px-4 mb-2 mt-4"

// ============================================================
// HEADER
// ============================================================

// Header: "relative z-10 mb-10 flex flex-col md:flex-row md:items-end justify-between gap-6"
// Page title: "text-4xl font-bold tracking-tight mb-2"
// Subtitle: "text-subtext-0 max-w-lg"
// Vibe label/badge: "inline-block px-3 py-1 rounded-lg bg-mauve/10 border border-mauve/20 text-mauve text-[10px] font-bold uppercase tracking-[0.2em] mb-4"

// ============================================================
// MODAL
// ============================================================

// Backdrop: "fixed inset-0 bg-crust/40 backdrop-blur-sm z-50 flex items-center justify-center"
// Modal card: GlassCard with "p-8 max-w-lg w-full mx-4"
// Modal title: "text-xl font-bold mb-4"
// Close button: "p-2 rounded-xl hover:bg-surface-0/40 text-subtext-1 hover:text-text transition-all"

// ============================================================
// BACKGROUND BLOBS (ambient depth)
// ============================================================

// Place these inside the main layout, behind content with pointer-events-none
// <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-mauve/10 blur-[120px] rounded-full pointer-events-none" />
// <div className="absolute bottom-[0%] right-[-5%] w-[35%] h-[35%] bg-blue/10 blur-[120px] rounded-full pointer-events-none" />
// <div className="absolute top-[20%] right-[10%] w-[25%] h-[25%] bg-pink/5 blur-[100px] rounded-full pointer-events-none" />

// ============================================================
// DROPDOWN
// ============================================================

// Dropdown container: GlassCard style, "bg-surface-0/60 backdrop-blur-xl border border-surface-2/30 rounded-2xl shadow-[0_8px_32px_0_rgba(0,0,0,0.2)] overflow-hidden"
// Dropdown item: "px-4 py-2.5 hover:bg-surface-0/40 transition-colors flex items-center gap-2 text-sm"
// Dropdown trigger: "flex items-center gap-2 px-4 py-2 rounded-xl bg-surface-0/40 border border-surface-2/30 hover:bg-surface-0/60 transition-all"

// ============================================================
// SELECT
// ============================================================

// Select container: "bg-surface-1/30 border border-surface-2/30 rounded-xl py-2.5 px-4 flex items-center justify-between cursor-pointer hover:border-surface-2/50 transition-all"
// Options dropdown: GlassCard style, "absolute top-full left-0 w-full mt-1 bg-surface-0/60 backdrop-blur-xl border border-surface-2/30 rounded-xl overflow-hidden z-50"
// Option item: "px-4 py-2.5 hover:bg-surface-0/40 transition-colors cursor-pointer"

// ============================================================
// CHECKBOX
// ============================================================

// Unchecked: "w-5 h-5 rounded-lg border-2 border-surface-2 bg-surface-1/30 transition-all hover:border-blue/50"
// Checked: "w-5 h-5 rounded-lg bg-blue border-2 border-blue flex items-center justify-center text-crust transition-all"

// ============================================================
// CALENDAR
// ============================================================

// Calendar container: GlassCard style
// Day cell: "w-10 h-10 rounded-xl flex items-center justify-center text-sm hover:bg-surface-0/40 transition-colors cursor-pointer"
// Selected day: "bg-blue text-crust rounded-xl"
// Today: "border border-blue/30"

// ============================================================
// FORM LAYOUT
// ============================================================

// Form field label: "text-sm font-medium text-subtext-1 mb-1.5"
// Form group: "flex flex-col gap-1.5"
// Form section: "flex flex-col gap-6"

// ============================================================
// LOGIN PAGE
// ============================================================

// Full-screen centered with background blobs
// Login card: GlassCard with generous padding "p-10"
// Logo area: gradient or glass treatment

// ============================================================
// SCROLLBAR (already handled in main CSS)
// ============================================================
// scrollbar-width: thin
// scrollbar-color uses overlay-0

// ============================================================
// TRANSITIONS & ANIMATIONS
// ============================================================

// Default transition: "transition-all duration-200" or "transition-colors"
// Hover lift: "hover:-translate-y-1 hover:shadow-2xl"
// Active press: "active:scale-95"
// Glass cards: "transition-all duration-500"
// Focus ring: "focus:ring-2 focus:ring-blue/30 focus:border-blue/50"

// ============================================================
// TYPOGRAPHY
// ============================================================

// Font: Inter, sans-serif (already set globally)
// Weight: 600 default (semi-bold)
// Page title: text-4xl font-bold tracking-tight
// Section title: text-xl font-bold
// Card title: text-3xl font-bold tracking-tight
// Body: text-sm
// Label: text-xs uppercase tracking-widest or tracking-[0.2em]
// Tiny: text-[10px] font-bold

// ============================================================
// SPACING
// ============================================================

// Page padding: p-4 md:p-8
// Card padding: p-6
// Modal padding: p-8
// Gap between cards: gap-6
// Gap inside forms: gap-6
// Gap between sections: mb-10
```

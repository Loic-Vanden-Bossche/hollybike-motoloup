export default {
  "packages/frontend/**/*.{js,jsx,ts,tsx,css}": () => [
    "bunx @moonrepo/cli run frontend:lint",
  ],
  "packages/app/**/*.dart": (files) => {
    const nonGeneratedFiles = files.filter(
      (file) =>
        !file.endsWith(".g.dart") &&
        !file.endsWith(".freezed.dart") &&
        !file.endsWith(".gr.dart"),
    );

    if (nonGeneratedFiles.length === 0) {
      return [];
    }

    return ["bunx @moonrepo/cli run app:lint"];
  },
  "packages/backend/**/*.{kt,kts}": () => [
    "bunx @moonrepo/cli run backend:lint",
  ],
  "packages/infrastructure/**/*.tf": () => [
    "bunx @moonrepo/cli run infrastructure:lint",
  ],
};

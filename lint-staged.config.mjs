const quote = (value) => `"${value.replace(/(["\\$`])/g, "\\$1")}"`;

export default {
  "packages/frontend/**/*.{js,jsx,ts,tsx,css}": () => [
    "cd packages/frontend && bun run lint",
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

    return ["cd packages/app && flutter analyze"];
  },
  "packages/backend/**/*.{kt,kts}": () => [
    "cd packages/backend && ./gradlew compileKotlin --quiet",
  ],
  "packages/infrastructure/**/*.tf": (files) => {
    const allFiles = files.map(quote).join(" ");
    return [`terraform fmt ${allFiles}`, `git add ${allFiles}`];
  },
};

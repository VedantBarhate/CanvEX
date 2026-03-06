const fs = require("fs")
const { execSync } = require("child_process")

// Read App.jsx
const code = fs.readFileSync("./src/App.jsx", "utf8")

// Find all import statements
const importRegex = /from\s+["']([^"']+)["']/g

const imports = new Set()
let match

while ((match = importRegex.exec(code)) !== null) {
  const lib = match[1]

  // Ignore relative imports
  if (!lib.startsWith(".") && !lib.startsWith("/")) {
    imports.add(lib.split("/")[0])
  }
}

if (imports.size === 0) {
  console.log("No external libraries detected.")
  process.exit()
}

console.log("Detected libraries:", [...imports])

// Read package.json
const pkg = JSON.parse(fs.readFileSync("./package.json"))

const installed = new Set([
  ...Object.keys(pkg.dependencies || {}),
  ...Object.keys(pkg.devDependencies || {})
])

const missing = [...imports].filter(lib => !installed.has(lib))

if (missing.length === 0) {
  console.log("All dependencies already installed.")
  process.exit()
}

console.log("Installing missing dependencies:", missing)

execSync(`npm install ${missing.join(" ")}`, { stdio: "inherit" })
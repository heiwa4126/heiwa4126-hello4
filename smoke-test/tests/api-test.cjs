const { hello } = require("@heiwa4126/hello4");

console.log("🔥 Testing CommonJS API...");
const result = hello();
console.log(`Result: ${result}`);

if (result !== "Hello!") {
	console.error("❌ Expected 'Hello!', got:", result);
	process.exit(1);
}

console.log("✅ CommonJS API test passed!");

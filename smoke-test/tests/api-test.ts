import { hello } from "@heiwa4126/hello4";

console.log("🔥 Testing TypeScript API...");
const result: string = hello();
console.log(`Result: ${result}`);

if (result !== "Hello!") {
	console.error("❌ Expected 'Hello!', got:", result);
	process.exit(1);
}

console.log("✅ TypeScript API test passed!");

// script/icon-gen.mjs
import { generateIcon } from 'icon-gen';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const svgFilePath = path.join(__dirname, '../icon.svg');
const destDirPath = path.join(__dirname, '../icon-build');

async function run() {
    try {
        const sizes = [16, 24, 32, 48, 64, 128, 256, 512, 1024];
        for (const size of sizes) {
            console.log(`Generating PNG for size ${size}`);
            const results = await generateIcon(svgFilePath, destDirPath, {
                report: true,
                pngSizes: [size]
            });
            console.log(`Icon generation succeeded for size ${size}:`, results);
        }
        // Generate app-512.png
        const appResults = await generateIcon(svgFilePath, destDirPath, {
            report: true,
            pngSizes: [512],
            name: 'app'
        });
        console.log('Icon generation succeeded for app-512:', appResults);
    } catch (err) {
        console.error('Icon generation failed:', err);
        process.exit(1);
    }
}

run();

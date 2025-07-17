import "./index.css";

import { StrictMode } from "react";
import { createRoot } from "react-dom/client";

import { ThemeProvider } from "@/components/ThemeProvider";

import App from "./App.tsx";

const rootElement = document.querySelector("#root");

if (!rootElement) {
    throw new Error("Failed to find the root element");
}

const root = createRoot(rootElement);

root.render(
    <ThemeProvider storageKey="vite-ui-theme">
        <StrictMode>
            <App />
        </StrictMode>,
    </ThemeProvider>
);

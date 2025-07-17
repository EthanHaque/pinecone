import { createContext, useContext, useEffect, useState } from "react";

type Theme = "dark" | "light" | "system";

type ThemeProviderProperties = {
    children: React.ReactNode;
    defaultTheme?: Theme;
    storageKey?: string;
};

type ThemeProviderState = {
    theme: Theme;
    setTheme: (theme: Theme) => void;
};

const initialState: ThemeProviderState = {
    theme: "system",
    setTheme: () => { },
};

const ThemeProviderContext = createContext<ThemeProviderState>(initialState);

export function ThemeProvider({ children, storageKey = "vite-ui-theme", ...properties }: ThemeProviderProperties) {
    const [theme, setTheme] = useState<Theme>(() => localStorage.getItem(storageKey) as Theme);

    useEffect(() => {
        const root = globalThis.document.documentElement;

        root.classList.remove("light", "dark");

        if (theme === "system") {
            const systemTheme = globalThis.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";

            root.classList.add(systemTheme);
            return;
        }

        root.classList.add(theme);
    }, [theme]);

    const value = {
        theme,
        setTheme: (theme: Theme) => {
            localStorage.setItem(storageKey, theme);
            setTheme(theme);
        },
    };

    return (
        <ThemeProviderContext.Provider {...properties} value={value}>
            {children}
        </ThemeProviderContext.Provider>
    );
}

export const useTheme = () => {
    return useContext(ThemeProviderContext);
};

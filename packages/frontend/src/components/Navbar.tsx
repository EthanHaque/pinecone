import { Logo } from "@/components/Logo";
import { ModeToggle } from "@/components/ModeToggle";
import { Button } from "@/components/ui/Button";
import { NavigationMenu, NavigationMenuItem, NavigationMenuList } from "@/components/ui/NavigationMenu";

const Navbar = () => {
    return (
        <header className="dark:bg-background sticky top-0 z-40 w-full border-b-[1px] bg-white dark:border-b-slate-700">
            <NavigationMenu className="mx-auto">
                <NavigationMenuList className="container flex h-14 w-screen justify-between px-4">
                    <NavigationMenuItem className="flex font-bold">
                        <a rel="noreferrer noopener" href="/" className="ml-2 flex text-xl font-bold">
                            <Logo />
                            Pinecone
                        </a>
                    </NavigationMenuItem>

                    <div className="hidden gap-2 md:flex">
                        <ModeToggle />

                        <Button variant="outline" className="">
                            Sign In
                        </Button>
                    </div>
                </NavigationMenuList>
            </NavigationMenu>
        </header>
    );
};

export default Navbar;

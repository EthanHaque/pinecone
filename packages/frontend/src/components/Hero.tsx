import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";

function Hero() {
  return (
    <div className="border-accent flex min-h-[calc(100vh-4rem)] w-full items-center justify-center overflow-hidden border-b">
      <div className="mx-auto flex w-full max-w-screen-xl flex-col items-center justify-between gap-x-10 gap-y-14 px-6 py-12 lg:flex-row lg:py-0">
        <div className="max-w-xl">
          <Badge className="rounded-full border-none py-1">Freshly Deployed</Badge>
          <h1 className="xs:text-4xl mt-6 max-w-[20ch] text-3xl !leading-[1.2] font-bold tracking-tight sm:text-5xl lg:text-[2.75rem] xl:text-5xl">
            Lorem Ipsum Dolor
          </h1>
          <p className="xs:text-lg mt-6 max-w-[60ch]">
            Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem
            aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
          </p>
          <div className="mt-12 flex flex-col items-center gap-4 sm:flex-row">
            <Button size="lg" className="w-full text-base sm:w-auto">
              To Dashboard
            </Button>
            <Button variant="outline" size="lg" className="w-full text-base shadow-none sm:w-auto">
              Sign Up
            </Button>
          </div>
        </div>
        <div className="hidden h-96 w-full max-w-xl rounded-lg bg-gray-200 lg:flex dark:bg-gray-800">
          {/* Placeholder for an image or illustration */}
        </div>
      </div>
    </div>
  );
}

export default Hero;

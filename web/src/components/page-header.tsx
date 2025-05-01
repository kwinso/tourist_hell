import { FlameIcon, Search, User } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Link } from "@tanstack/react-router";

export function PageHeader() {
  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex items-center justify-between h-16 px-4 mx-auto">
        <Link to="/" className="flex items-center gap-2">
          <FlameIcon className="w-6 h-6 text-primary" />
          <span className="text-xl font-bold">Tourist Hell</span>
        </Link>

        <div className="hidden md:flex md:flex-1 md:items-center md:justify-center md:px-6">
          <div className="relative w-full max-w-md">
            <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
            <Input
              type="search"
              placeholder="Search destinations..."
              className="w-full pl-8 bg-background"
            />
          </div>
        </div>

        <div className="flex items-center gap-4">
          <Button variant="ghost" size="sm" className="hidden md:flex">
            Help
          </Button>
          <Button variant="ghost" size="icon" className="md:hidden">
            <Search className="w-5 h-5" />
            <span className="sr-only">Search</span>
          </Button>
          <Button variant="outline" size="sm" className="gap-2">
            <User className="w-4 h-4" />
            <span className="hidden sm:inline">Account</span>
          </Button>
        </div>
      </div>
    </header>
  );
}

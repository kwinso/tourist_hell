import { createFileRoute } from "@tanstack/react-router";

import { Button } from "@/components/ui/button";
import { TourGrid } from "@/components/tour-grid";
import { PageHeader } from "@/components/page-header";
import { useState } from "react";

export const Route = createFileRoute("/")({
  component: App,
});

function App() {
  const [search, setSearch] = useState("");
  return (
    <div>
      <main className="min-h-screen bg-gradient-to-b from-sky-50 to-white">
        <PageHeader onSearchChange={setSearch} />
        <div className="container px-4 py-8 mx-auto">
          <h1 className="mb-2 text-3xl font-bold tracking-tight text-center sm:text-4xl md:text-5xl">
            Discover Your Next Adventure
          </h1>
          <p className="max-w-2xl mx-auto mb-10 text-center text-muted-foreground">
            Explore our handpicked selection of tours and experiences, crafted
            to create unforgettable memories.
          </p>
          <TourGrid search={search} />
        </div>
      </main>
    </div>
  );
}

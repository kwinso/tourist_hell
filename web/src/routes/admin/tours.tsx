import { createFileRoute } from "@tanstack/react-router";
import { useDebounce } from "use-debounce";
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

export const Route = createFileRoute("/admin/tours")({
  component: RouteComponent,
});

import { useEffect, useState } from "react";
import {
  APIError,
  createTour,
  deleteTour,
  getTours,
  updateTour,
  type Tour,
} from "@/api";
import { Edit, Trash } from "lucide-react";
import { Button } from "@/components/ui/button";
import { TourDialog } from "@/components/tour-dialog";
import { Input } from "@/components/ui/input";

function RouteComponent() {
  const [tours, setTours] = useState<Tour[]>([]);
  const [editedTour, setEditedTour] = useState<Tour | undefined>(undefined);
  const [search, setSearch] = useState("");
  const [debouncedSearch] = useDebounce(search, 500);

  useEffect(() => {
    getTours(debouncedSearch).then(setTours);
  }, [debouncedSearch]);

  return (
    <div className="flex flex-1 flex-col">
      <div className="@container/main flex flex-1 flex-col gap-2">
        <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6 px-4">
          <div className="flex gap-2">
            <Button
              variant="outline"
              onClick={() =>
                setEditedTour({
                  name: "New Tour",
                  description: "",
                  destinationCountry: "",
                  closestTourDate: new Date().toISOString().slice(0, -5) + "Z",
                  id: "",
                })
              }
            >
              New tour
            </Button>

            <Input
              placeholder="Search"
              onChange={(e) => setSearch(e.target.value)}
              className="w-[200px]"
              value={search}
            />
          </div>
          <TourDialog
            tour={editedTour ?? undefined}
            onClose={() => setEditedTour(undefined)}
            onSave={async (tour) => {
              try {
                if (tour.id) {
                  await updateTour(tour);
                  const newTours = tours.map((t) =>
                    t.id === tour.id ? tour : t
                  );
                  setTours(newTours);
                } else {
                  const newTour = await createTour(tour);
                  setTours([...tours, newTour]);
                }
              } catch (error) {
                if (error instanceof APIError) {
                  alert(error.message);
                }
                return;
              }
              setEditedTour(undefined);
            }}
            open={!!editedTour}
          />
          <Table>
            <TableCaption>A list of clients in the system</TableCaption>
            <TableHeader>
              <TableRow>
                <TableHead>Name</TableHead>
                <TableHead>Description</TableHead>
                <TableHead>Destination Country</TableHead>
                <TableHead>Closest Tour Date</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {tours.map((tour) => (
                <TableRow key={tour.id}>
                  <TableCell className="font-medium">{tour.name}</TableCell>
                  <TableCell className="font-medium">
                    {tour.description}
                  </TableCell>
                  <TableCell className="font-medium">
                    {tour.destinationCountry}
                  </TableCell>
                  <TableCell className="font-medium">
                    {tour.closestTourDate}
                  </TableCell>
                  <TableCell className="font-medium flex gap-1">
                    <Button
                      variant="outline"
                      size="icon"
                      onClick={() => setEditedTour(tour)}
                    >
                      <Edit />
                    </Button>
                    <Button
                      variant="outline"
                      size="icon"
                      onClick={async () => {
                        try {
                          await deleteTour(tour);
                        } catch (error) {
                          if (error instanceof APIError) {
                            alert(error.message);
                          }
                          return;
                        }
                        const newTours = tours.filter((t) => t.id !== tour.id);
                        setTours(newTours);
                      }}
                    >
                      <Trash />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </div>
    </div>
  );
}

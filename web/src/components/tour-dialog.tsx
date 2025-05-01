import type { Tour } from "@/api";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useEffect, useState } from "react";
import { Calendar } from "./ui/calendar";
import { format } from "date-fns";
import { Textarea } from "./ui/textarea";

interface TourDialogProps {
  tour?: Tour;
  onSave: (tour: Tour) => void;
  onClose: () => void;
  open: boolean;
}

export function TourDialog({
  open,
  tour: initialTour,
  onSave,
  onClose,
}: TourDialogProps) {
  const [tour, setTour] = useState<Partial<Tour>>(initialTour ?? {});

  useEffect(() => {
    setTour(initialTour ?? {});
  }, [initialTour]);
  return (
    <Dialog open={open} onOpenChange={(isOpen) => !isOpen && onClose()}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>{tour ? "Edit Tour" : "Add Tour"}</DialogTitle>
        </DialogHeader>

        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="name" className="text-right">
              Name
            </Label>
            <Input
              className="col-span-3"
              value={tour.name ?? ""}
              onChange={(e) => setTour({ ...tour, name: e.target.value })}
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="username" className="text-right">
              Description
            </Label>
            <Textarea
              className="col-span-3"
              required
              value={tour.description ?? ""}
              onChange={(e) =>
                setTour({ ...tour, description: e.target.value })
              }
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="email" className="text-right">
              Destination Country
            </Label>
            <Input
              className="col-span-3"
              value={tour.destinationCountry ?? ""}
              onChange={(e) =>
                setTour({
                  ...tour,
                  destinationCountry: e.target.value,
                })
              }
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label className="text-right">Closest Tour Date</Label>
            {tour.closestTourDate ? (
              format(tour.closestTourDate, "dd/MM/yyyy")
            ) : (
              <span>Pick a date</span>
            )}
          </div>
        </div>

        <Calendar
          className="m-auto"
          mode="single"
          selected={new Date(tour.closestTourDate ?? "")}
          onSelect={(date) =>
            setTour({
              ...tour,
              closestTourDate: date!.toISOString().slice(0, -5) + "Z",
            })
          }
          initialFocus
        />
        <DialogFooter>
          <Button type="submit" onClick={() => onSave(tour as Tour)}>
            Save changes
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

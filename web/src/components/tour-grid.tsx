"use client";

import { useEffect, useState } from "react";
import { TourCard } from "@/components/tour-card";
import { TourDetails } from "@/components/tour-details";
import { getTours, type Tour } from "@/api";

interface TourGridProps {
  search: string;
}

export function TourGrid({ search }: TourGridProps) {
  const [selectedTour, setSelectedTour] = useState<string | null>(null);
  const [tours, setTours] = useState<Tour[]>([]);

  useEffect(() => {
    getTours(search).then(setTours);
  }, [search]);

  const handleOpenDetails = (tourId: string) => {
    setSelectedTour(tourId);
  };

  const handleCloseDetails = () => {
    setSelectedTour(null);
  };

  return (
    <div>
      <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {tours.map((tour) => (
          <TourCard
            key={tour.id}
            tour={tour}
            onViewDetails={() => handleOpenDetails(tour.id)}
          />
        ))}
      </div>

      {selectedTour && (
        <TourDetails
          tour={tours.find((t) => t.id === selectedTour)!}
          onClose={handleCloseDetails}
        />
      )}
    </div>
  );
}

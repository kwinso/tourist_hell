"use client";

// import Image from "next/image";
import { Calendar, Clock, MapPin } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { StarRating } from "@/components/star-rating";
import { getRatings, type Review, type Tour } from "@/api";
import { useEffect, useState } from "react";

interface TourCardProps {
  tour: Tour;
  onViewDetails: () => void;
}

export function TourCard({ tour, onViewDetails }: TourCardProps) {
  const [reviews, setReviews] = useState<Review[]>([]);

  useEffect(() => {
    getRatings(tour.id).then(setReviews);
  }, []);

  return (
    <Card className="overflow-hidden transition-all duration-300 hover:shadow-lg">
      <div className="relative aspect-[4/3] overflow-hidden">
        <img
          src={import.meta.env.VITE_API_URL + tour.banner}
          alt={tour.name}
          className="object-cover transition-transform duration-300 hover:scale-105"
        />
      </div>
      <CardContent className="p-4">
        <div className="flex items-start justify-between mb-2">
          <h3 className="text-lg font-semibold line-clamp-1">{tour.name}</h3>
        </div>
        <div className="flex items-center gap-1 mb-2 text-muted-foreground">
          <MapPin className="w-4 h-4" />
          <span className="text-sm">{tour.destinationCountry}</span>
        </div>
        <p className="mb-3 text-sm text-muted-foreground line-clamp-2">
          {tour.description}
        </p>
        <div className="flex items-center justify-between">
          <StarRating
            rating={
              reviews.reduce((acc, review) => acc + review.rating, 0) /
              reviews.length
            }
          />
          <span className="text-sm text-muted-foreground">
            {reviews.length} {reviews.length === 1 ? "review" : "reviews"}
          </span>
        </div>
      </CardContent>
      <CardFooter className="flex items-center justify-between p-4 pt-0 border-t border-muted/30">
        <Button size="sm" onClick={onViewDetails}>
          View
        </Button>
      </CardFooter>
    </Card>
  );
}

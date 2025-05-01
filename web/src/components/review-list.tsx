"use client";

import { useState, useEffect } from "react";
import { ReviewItem } from "@/components/review-item";
import type { Review } from "@/api";

interface ReviewListProps {
  ratings: Review[];
  tourId?: string;
}

export function ReviewList({ ratings, tourId }: ReviewListProps) {
  // In a real app, we would fetch reviews from an API
  // Here we're using client-side state to simulate that
  const [reviews, setReviews] = useState<Review[]>(ratings);

  // Listen for new review events
  const handleNewReview = (event: CustomEvent) => {
    if (event.detail.tourId === tourId) {
      setReviews((prev) => [event.detail, ...prev]);
    }
  };

  useEffect(() => {
    window.addEventListener("newReview" as any, handleNewReview);
    return () => {
      window.removeEventListener("newReview" as any, handleNewReview);
    };
  }, [tourId]);

  if (reviews.length === 0) {
    return (
      <div className="py-8 text-center text-muted-foreground">
        No reviews yet. Be the first to leave a review!
      </div>
    );
  }

  return (
    <div className="space-y-6 max-h-[300px] overflow-auto">
      {reviews.map((review) => (
        <ReviewItem key={review.id} review={review} />
      ))}
    </div>
  );
}

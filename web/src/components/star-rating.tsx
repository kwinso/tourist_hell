"use client";

import { Star } from "lucide-react";

interface StarRatingProps {
  rating: number;
  max?: number;
  size?: "sm" | "md" | "lg";
  interactive?: boolean;
  onChange?: (rating: number) => void;
}

export function StarRating({
  rating,
  max = 5,
  size = "md",
  interactive = false,
  onChange,
}: StarRatingProps) {
  const sizeClass = {
    sm: "w-3 h-3",
    md: "w-4 h-4",
    lg: "w-5 h-5",
  }[size];

  const handleClick = (index: number) => {
    if (interactive && onChange) {
      onChange(index + 1);
    }
  };

  return (
    <div className="flex">
      {Array.from({ length: max }).map((_, index) => (
        <Star
          key={index}
          className={`${sizeClass} ${
            index < Math.floor(rating)
              ? "fill-primary text-primary"
              : index < rating
                ? "fill-primary text-primary opacity-60"
                : "text-muted"
          } 
            ${interactive ? "cursor-pointer" : ""}`}
          onClick={() => handleClick(index)}
        />
      ))}
    </div>
  );
}

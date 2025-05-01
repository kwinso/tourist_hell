"use client";

import type React from "react";

import { useState } from "react";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { StarRating } from "@/components/star-rating";
import { createRating, type Review } from "@/api";
import { Input } from "./ui/input";

interface ReviewFormProps {
  tourId: string;
}

export function ReviewForm({ tourId }: ReviewFormProps) {
  const [rating, setRating] = useState(0);
  const [name, setName] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    // Validate form
    if (rating === 0) {
      setError("Please select a rating");
      return;
    }

    if (!name.trim()) {
      setError("Please enter a comment");
      return;
    }

    setIsSubmitting(true);

    // Dispatch custom event to update the review list
    const review = await createRating(tourId, name, rating);
    const event = new CustomEvent("newReview", { detail: review });
    window.dispatchEvent(event);

    // Reset form
    setRating(0);
    setName("");
    setIsSubmitting(false);
    setSuccess(true);

    // Hide success message after 3 seconds
    setTimeout(() => setSuccess(false), 3000);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div className="space-y-4">
        <div>
          <label htmlFor="comment" className="block mb-2 text-sm font-medium">
            Your Review
          </label>
          <Input
            id="name"
            placeholder="What's your name?"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
          {error === "Please enter a comment" && (
            <p className="mt-1 text-sm text-red-500">{error}</p>
          )}
        </div>
        <div>
          <label className="block mb-2 text-sm font-medium">Your Rating</label>
          <StarRating
            rating={rating}
            size="lg"
            interactive
            onChange={setRating}
          />
          {error === "Please select a rating" && (
            <p className="mt-1 text-sm text-red-500">{error}</p>
          )}
        </div>

        <div className="flex items-center justify-between">
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? "Submitting..." : "Submit Review"}
          </Button>

          {success && (
            <p className="text-sm text-green-600">
              Your review has been submitted successfully!
            </p>
          )}
        </div>
      </div>
    </form>
  );
}

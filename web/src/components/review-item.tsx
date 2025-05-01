import { formatDistanceToNow } from "date-fns";
import { StarRating } from "@/components/star-rating";
import type { Review } from "@/api";

interface ReviewItemProps {
  review: Review;
}

export function ReviewItem({ review }: ReviewItemProps) {
  return (
    <div className="p-4 border rounded-lg">
      <div className="flex items-start gap-4">
        <div className="flex-1">
          <div className="flex items-center justify-between">
            <h4 className="font-medium">{review.name}</h4>
          </div>

          <div className="mt-1 mb-2">
            <StarRating rating={review.rating} />
          </div>
        </div>
      </div>
    </div>
  );
}

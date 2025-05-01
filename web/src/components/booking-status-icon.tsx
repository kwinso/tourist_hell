import type { BookingStatus } from "@/api";
import {
  BookmarkIcon,
  CheckCircleIcon,
  CircleDollarSignIcon,
} from "lucide-react";

interface BookingStatusIconProps {
  status: BookingStatus;
}

export function BookingStatusIcon({ status }: BookingStatusIconProps) {
  if (status === "created") {
    return <BookmarkIcon className="w-5 h-5" />;
  }
  if (status === "confirmed") {
    return <CheckCircleIcon className="w-5 h-5" />;
  }
  if (status === "paid") {
    return <CircleDollarSignIcon className="w-5 h-5" />;
  }
}

"use client";

import { useEffect, useState } from "react";
import { CalendarIcon, MapPin } from "lucide-react";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { StarRating } from "@/components/star-rating";
import { ReviewList } from "@/components/review-list";
import { ReviewForm } from "@/components/review-form";
import { APIError, bookTour, getRatings, type Review, type Tour } from "@/api";
import { Input } from "./ui/input";
import { useForm } from "react-hook-form";
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "./ui/form";
import { toast } from "sonner";
import { Popover, PopoverContent, PopoverTrigger } from "./ui/popover";
import { format } from "date-fns";
import { cn } from "@/lib/utils";
import { Calendar } from "./ui/calendar";

interface TourDetailsProps {
  tour: Tour;
  onClose: () => void;
}

const bookTourSchema = z.object({
  name: z
    .string()
    .min(5, { message: "Name is too short" })
    .max(25, { message: "Name is too long" }),
  phone: z
    .string()
    .min(10, { message: "Phone number is too short" })
    .max(15, { message: "Phone number is too long" }),
  age: z.coerce
    .number()
    .min(18, {
      message: "You have to be at least 18 years old",
    })
    .max(65, {
      message: "You have to be at most 65 years old",
    }),
  tourDate: z
    .date()
    .min(new Date(+new Date().setHours(0, 0, 0, 0) + 86400000), {
      message: "Date should be at least tomorrow",
    }),
});

export function TourDetails({ tour, onClose }: TourDetailsProps) {
  const [activeTab, setActiveTab] = useState("overview");
  const [reviews, setReviews] = useState<Review[]>([]);
  const [bookingDialogOpen, setBookingDialogOpen] = useState(false);
  const form = useForm<z.infer<typeof bookTourSchema>>({
    resolver: zodResolver(bookTourSchema),
    defaultValues: {
      name: "",
      phone: "",
      age: 18,
      tourDate: new Date(),
    },
  });

  async function onSubmit(values: z.infer<typeof bookTourSchema>) {
    try {
      await bookTour(
        tour,
        values.name,
        values.phone,
        values.age,
        values.tourDate
      );
      setBookingDialogOpen(false);
      toast.success("Successfully booked tour");
    } catch (e) {
      if (e instanceof APIError) {
        toast.error(e.message);
        return;
      }
      throw e;
    }
  }

  useEffect(() => {
    getRatings(tour.id).then(setReviews);

    window.addEventListener("newReview" as any, handleNewReview);
    return () => {
      window.removeEventListener("newReview" as any, handleNewReview);
    };
  }, [tour.id]);

  // Listen for new review events
  const handleNewReview = (event: CustomEvent) => {
    if (event.detail.tourId === tour.id) {
      setReviews((prev) => [event.detail, ...prev]);
    }
  };
  return (
    <Dialog open={true} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-w-3xl p-0 overflow-auto">
        <DialogHeader className="p-6 pb-0">
          <div className="flex items-start justify-between">
            <DialogTitle className="text-2xl font-bold">
              {tour.name}
            </DialogTitle>
          </div>
          <div className="flex items-center gap-2 mt-2 text-muted-foreground">
            <MapPin className="w-4 h-4" />
            <span>{tour.destinationCountry}</span>
          </div>
        </DialogHeader>

        <div className="p-6">
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="w-full">
              <TabsTrigger value="overview" className="flex-1">
                Overview
              </TabsTrigger>
              <TabsTrigger value="reviews" className="flex-1">
                Reviews ({reviews.length})
              </TabsTrigger>
            </TabsList>

            <TabsContent value="overview" className="pt-4">
              <div className="prose max-w-none">
                <p>{tour.description}</p>
              </div>

              <div className="flex justify-center mt-6">
                <Dialog
                  open={bookingDialogOpen}
                  onOpenChange={setBookingDialogOpen}
                >
                  <DialogTrigger asChild>
                    <Button size="lg">Book This Tour</Button>
                  </DialogTrigger>
                  <DialogContent className="sm:max-w-[425px]">
                    <DialogHeader>
                      <DialogTitle>Book tour</DialogTitle>
                      <DialogDescription>
                        Leave your personal details, we'll contant you as soon
                        as we can
                      </DialogDescription>
                    </DialogHeader>

                    <Form {...form}>
                      <form
                        onSubmit={form.handleSubmit(onSubmit)}
                        className="space-y-8"
                      >
                        <FormField
                          control={form.control}
                          name="name"
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Your name</FormLabel>
                              <FormControl>
                                <Input placeholder="Bob Dylan" {...field} />
                              </FormControl>
                              <FormDescription>
                                How should we call you?
                              </FormDescription>
                              <FormMessage />
                            </FormItem>
                          )}
                        />
                        <FormField
                          control={form.control}
                          name="phone"
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Your phone number</FormLabel>
                              <FormControl>
                                <Input placeholder="123-456-7890" {...field} />
                              </FormControl>
                              <FormDescription>
                                What's your phone number?
                              </FormDescription>
                              <FormMessage />
                            </FormItem>
                          )}
                        />
                        <FormField
                          control={form.control}
                          name="age"
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Your age</FormLabel>
                              <FormControl>
                                <Input
                                  type="number"
                                  placeholder="18"
                                  {...field}
                                />
                              </FormControl>
                              <FormDescription>
                                How old are you?
                              </FormDescription>
                              <FormMessage />
                            </FormItem>
                          )}
                        />
                        <FormField
                          control={form.control}
                          name="tourDate"
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Your tour date</FormLabel>
                              <FormControl>
                                <Calendar
                                  mode="single"
                                  selected={field.value}
                                  initialFocus
                                  onSelect={(date) => field.onChange(date)}
                                />
                              </FormControl>
                              <FormDescription>
                                When do you want to go?
                              </FormDescription>
                              <FormMessage />
                            </FormItem>
                          )}
                        />
                        <Button type="submit">Submit</Button>
                      </form>
                    </Form>
                  </DialogContent>
                </Dialog>
              </div>
            </TabsContent>

            <TabsContent value="reviews" className="pt-4">
              <div className="flex items-center gap-2 mb-4">
                <StarRating
                  rating={
                    reviews.reduce((acc, review) => acc + review.rating, 0) /
                    reviews.length
                  }
                  size="lg"
                />
                <span className="text-lg font-medium">
                  {(
                    reviews.reduce((acc, review) => acc + review.rating, 0) /
                    reviews.length
                  ).toFixed(1)}
                </span>
                <span className="text-muted-foreground">
                  ({reviews.length}{" "}
                  {reviews.length === 1 ? "review" : "reviews"})
                </span>
              </div>

              <ReviewList ratings={reviews} tourId={tour.id} />

              <div className="mt-8 pt-6 border-t">
                <h4 className="mb-4 text-lg font-semibold">Leave a Review</h4>
                <ReviewForm tourId={tour.id} />
              </div>
            </TabsContent>
          </Tabs>
        </div>
      </DialogContent>
    </Dialog>
  );
}

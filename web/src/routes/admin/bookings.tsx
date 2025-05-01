import { createFileRoute } from "@tanstack/react-router";
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

export const Route = createFileRoute("/admin/bookings")({
  component: RouteComponent,
});

import { useEffect, useState } from "react";
import {
  APIError,
  BookingStatus,
  getBookings,
  setBookingStatus,
  type Booking,
} from "@/api";
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectValue,
  SelectTrigger,
} from "@/components/ui/select";
import { BookingStatusIcon } from "@/components/booking-status-icon";

function RouteComponent() {
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [shownStatus, setShownStatus] = useState<BookingStatus | null>(null);

  useEffect(() => {
    getBookings(shownStatus).then(setBookings);
  }, [shownStatus]);

  return (
    <div className="flex flex-1 flex-col">
      <div className="@container/main flex flex-1 flex-col gap-2">
        <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6 px-4">
          Status
          <Select
            onValueChange={(val) =>
              setShownStatus(val == "all" ? null : (val as BookingStatus))
            }
          >
            <SelectTrigger className="w-[180px]">
              <SelectValue placeholder="Statuses to show" />
            </SelectTrigger>
            <SelectContent>
              <SelectGroup>
                <SelectLabel>Select status</SelectLabel>
                <SelectItem value="all">All</SelectItem>
                <SelectItem value="created">Created</SelectItem>
                <SelectItem value="confirmed">Confirmed</SelectItem>
                <SelectItem value="paid">Paid</SelectItem>
              </SelectGroup>
            </SelectContent>
          </Select>
          <Table>
            <TableCaption>A list of bookings in the system</TableCaption>
            <TableHeader>
              <TableRow>
                <TableHead className="w-1/5">Client</TableHead>
                <TableHead className="w-3/5">Tour</TableHead>
                <TableHead>Status</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {bookings.map((booking) => (
                <TableRow key={booking.id}>
                  <TableCell className="font-medium">
                    {booking.client.name}
                  </TableCell>
                  <TableCell>{booking.tour.name}</TableCell>
                  <TableCell>
                    <Select
                      value={booking.status}
                      onValueChange={async (val) => {
                        try {
                          await setBookingStatus(booking, val as BookingStatus);
                        } catch (e) {
                          if (e instanceof APIError) {
                            alert(e.message);
                            return;
                          }
                          throw e;
                        }

                        const newBookings = bookings.map((b) => {
                          if (b.id === booking.id) {
                            return {
                              ...b,
                              status: val as BookingStatus,
                            };
                          }
                          return b;
                        });
                        setBookings(newBookings);
                      }}
                    >
                      <SelectTrigger className="flex gap-3 w-[180px]">
                        <BookingStatusIcon status={booking.status} />
                        <SelectValue placeholder="Select a fruit" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectGroup>
                          <SelectLabel>Statuses</SelectLabel>
                          <SelectItem value="created">
                            {/* <BookingStatusIcon status={BookingStatus.created} /> */}
                            Created
                          </SelectItem>
                          <SelectItem value="confirmed">
                            {/* <BookingStatusIcon
                              status={BookingStatus.confirmed}
                            /> */}
                            Confirmed
                          </SelectItem>
                          <SelectItem value="paid">
                            {/* <BookingStatusIcon status={BookingStatus.paid} /> */}
                            Paid
                          </SelectItem>
                        </SelectGroup>
                      </SelectContent>
                    </Select>
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

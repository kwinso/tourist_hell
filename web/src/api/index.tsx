import axios, { type AxiosResponse } from "axios";
const API_ROUTE = import.meta.env.VITE_API_URL;

const client = axios.create({
  baseURL: API_ROUTE,
});
const token = localStorage.getItem("token");
if (token) {
  client.defaults.headers.common["Authorization"] = `Bearer ${token}`;
}

async function tryCatchAPIError(
  requestFn: () => Promise<AxiosResponse>
): Promise<AxiosResponse> {
  try {
    return await requestFn();
  } catch (error) {
    if (axios.isAxiosError(error)) {
      console.error("here");
      throw new APIError(error.response?.data.reason, error.response?.data);
    }
    throw error;
  }
}

export function isLoggedIn(): boolean {
  return !!localStorage.getItem("token");
}

export class APIError extends Error {
  constructor(
    message: string,
    public readonly rawValue: object
  ) {
    super(message);
  }
}

export async function login(username: string, password: string) {
  const resp = await tryCatchAPIError(async () =>
    client.post("/auth/admin", {}, { auth: { username, password } })
  );
  client.defaults.headers.common["Authorization"] = `Bearer ${resp.data.token}`;

  localStorage.setItem("token", resp.data.token);
}

export function logout() {
  localStorage.removeItem("token");
  client.defaults.headers.common["Authorization"] = "";
}

export interface Client {
  id: string;
  name: string;
  phoneNumber: string;
  age: number;
}

export async function getClients(): Promise<Client[]> {
  const resp = await tryCatchAPIError(async () => client.get("clients"));
  return resp.data;
}

export interface Tour {
  id: string;
  name: string;
  description: string;
  destinationCountry: string;
  closestTourDate: string;
}

export async function getTours(search: string): Promise<Tour[]> {
  const resp = await tryCatchAPIError(() =>
    client.get("tours", { params: { search } })
  );
  return resp.data;
}

export async function createTour(tour: Tour) {
  const resp = await tryCatchAPIError(() => client.post("tours", tour));
  return resp.data;
}

export async function updateTour(tour: Tour) {
  const resp = await tryCatchAPIError(() =>
    client.patch(`/tours/${tour.id}`, tour)
  );
  return resp.data;
}

export async function deleteTour(tour: Tour) {
  const resp = await tryCatchAPIError(() => client.delete(`/tours/${tour.id}`));
  return resp.data;
}

export enum BookingStatus {
  created = "created",
  confirmed = "confirmed",
  paid = "paid",
}

export interface Booking {
  id: string;
  tour: Tour;
  client: Client;
  tourDate: string;
  status: BookingStatus;
}

export async function getBookings(
  shownStatus: BookingStatus | null
): Promise<Booking[]> {
  const resp = await tryCatchAPIError(() =>
    client.get("bookings", { params: { status: shownStatus } })
  );
  return resp.data;
}

export async function setBookingStatus(
  booking: Booking,
  status: BookingStatus
) {
  const resp = await tryCatchAPIError(() =>
    client.patch(`/bookings/${booking.id}/status`, { status })
  );
  return resp.data;
}

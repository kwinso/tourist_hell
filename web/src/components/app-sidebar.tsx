import * as React from "react";
import { Map, Ticket, User, Flame } from "lucide-react";

import { NavMain } from "@/components/nav-main";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "@/components/ui/sidebar";
import { Button } from "./ui/button";
import { logout } from "@/api";
import { useNavigate } from "@tanstack/react-router";

const navMain = [
  {
    title: "Clients",
    url: "/admin/clients",
    icon: User,
  },
  {
    title: "Tours",
    url: "/admin/tours",
    icon: Map,
  },
  {
    title: "Bookings",
    url: "/admin/bookings",
    icon: Ticket,
  },
];

export function AppSidebar({ ...props }: React.ComponentProps<typeof Sidebar>) {
  const navigate = useNavigate();
  function doLogout() {
    logout();
    navigate({ to: "/" });
  }

  return (
    <Sidebar collapsible="offcanvas" {...props}>
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton
              asChild
              className="data-[slot=sidebar-menu-button]:!p-1.5"
            >
              <a href="#">
                <Flame className="!size-5" />
                <span className="text-base font-semibold">
                  Tourist Hell Admin
                </span>
              </a>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>
      <SidebarContent>
        <NavMain items={navMain} />
      </SidebarContent>
      <SidebarFooter>
        <Button variant="destructive" onClick={doLogout}>
          Log out
        </Button>
      </SidebarFooter>
    </Sidebar>
  );
}

import { useEffect, useState } from "react";

export interface ConditionalPortalProps {
  portal: React.FC<{ children?: React.ReactNode }>;
  children: React.ReactNode;
}

export const ConditionalPortal = ({
  portal: Portal,
  children,
}: ConditionalPortalProps) => {
  const [hasDialog, setHasDialog] = useState(false);

  useEffect(() => {
    setHasDialog(!!document.querySelector("[role=dialog]"));
  }, []);

  if (hasDialog) {
    return children;
  }

  return <Portal>{children}</Portal>;
};

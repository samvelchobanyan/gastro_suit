export interface ScreenHeaderProps {
  /** Page title, rendered in Heading 1 style. */
  title?: string;
  /** Show a back button when a handler is provided. */
  onBack?: (() => void) | null;
  /** Optional right-side action node (icon button, link, etc). */
  action?: React.ReactNode;
}

export function ScreenHeader(props: ScreenHeaderProps): JSX.Element;

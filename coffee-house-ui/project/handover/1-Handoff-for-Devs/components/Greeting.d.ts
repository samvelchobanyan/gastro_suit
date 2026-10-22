export interface GreetingProps {
  /** Person's name shown after "Hi,". */
  name?: string;
  /** Overline text above the name. Default "Greetings". */
  greeting?: string;
  /** Brand logo URL. Falls back to a placeholder brand mark (white-label). */
  logoUrl?: string | null;
  /** Show the unread dot on the bell. Default true. */
  hasNotifications?: boolean;
  onBellClick?: () => void;
}

export function Greeting(props: GreetingProps): JSX.Element;

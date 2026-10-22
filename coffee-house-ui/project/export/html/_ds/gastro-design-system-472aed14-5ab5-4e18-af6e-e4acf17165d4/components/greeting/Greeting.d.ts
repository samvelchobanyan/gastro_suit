export interface GreetingProps {
  /** Person's name shown after "Hi,". */
  name?: string;
  /** Overline text above the name. Default "Greetings". */
  greeting?: string;
  /** Brand logo URL. Falls back to a placeholder brand mark (white-label). */
  logoUrl?: string | null;
  /** User profile photo URL (profile variant). Placeholder when null. */
  avatarUrl?: string | null;
  /** Show the unread dot on the bell. Default true. */
  hasNotifications?: boolean;
  /** Show the notification dot on the avatar (profile variant). Default true. */
  hasAvatarNotification?: boolean;
  onBellClick?: () => void;
  onProfileClick?: () => void;
  /** `default` (logo + greeting text) or `profile` (avatar · centered logo · bell). */
  variant?: 'default' | 'profile';
}

export function Greeting(props: GreetingProps): JSX.Element;

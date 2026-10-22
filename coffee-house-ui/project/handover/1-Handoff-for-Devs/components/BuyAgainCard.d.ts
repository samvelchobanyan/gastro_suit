export interface BuyAgainCardProps {
  /** Product name — Body Regular. */
  name?: string;
  /** Location line — Body Small, with a pin icon. */
  location?: string;
  /** Product photo URL. Placeholder when null. */
  imageUrl?: string | null;
  /** Card width in px. Default 128. */
  width?: number;
  onClick?: () => void;
}

export function BuyAgainCard(props: BuyAgainCardProps): JSX.Element;

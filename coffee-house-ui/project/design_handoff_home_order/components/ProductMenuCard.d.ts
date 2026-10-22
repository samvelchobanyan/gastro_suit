export interface ProductMenuCardProps {
  /** Product name — Body Small. */
  name?: string;
  /** Price line — Body Small Semibold (pre-formatted string). */
  price?: string;
  /** Product photo URL. Placeholder when null. */
  imageUrl?: string | null;
  /** Card width in px. Default 160. */
  width?: number;
  onClick?: () => void;
}

export function ProductMenuCard(props: ProductMenuCardProps): JSX.Element;

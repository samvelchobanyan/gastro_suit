export interface ProductVerticalCardProps {
  /** Product name — Body Small. */
  name?: string;
  /** Price line — Body Extra Small (pre-formatted string). */
  price?: string;
  /** Product photo URL. Placeholder when null. */
  imageUrl?: string | null;
  /** Card width in px. Default 128. */
  width?: number;
  onClick?: () => void;
}

export function ProductVerticalCard(props: ProductVerticalCardProps): JSX.Element;

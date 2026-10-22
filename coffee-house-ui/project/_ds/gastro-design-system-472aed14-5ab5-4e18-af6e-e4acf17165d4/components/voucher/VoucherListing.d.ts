export interface VoucherListingProps {
  /** Voucher name — Body Small Semibold. */
  name?: string;
  /** Voucher photo URL. Placeholder when null. */
  imageUrl?: string | null;
  /** Card width in px. Default 160. */
  width?: number;
  onClick?: () => void;
}

export function VoucherListing(props: VoucherListingProps): JSX.Element;

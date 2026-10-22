export interface VoucherProps {
  /** Product name (Body Regular). */
  name?: string;
  /** Remaining count shown as "{n} remaining" (Body Small). */
  remaining?: number;
  /** Per-client product image URL. Placeholder when null. */
  image?: string | null;
}

export function Voucher(props: VoucherProps): JSX.Element;

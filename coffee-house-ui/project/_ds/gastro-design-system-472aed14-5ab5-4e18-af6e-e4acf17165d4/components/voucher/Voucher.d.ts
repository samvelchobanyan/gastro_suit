export interface VoucherProps {
  /** Product name (Body Regular). */
  name?: string;
  /** Remaining count, shown as a "×n" badge top-right. Hidden when 0. */
  remaining?: number;
  /** Optional second line (Body Small), e.g. "Valid until 31 Dec". */
  subtitle?: string | null;
  /** Per-client product image URL. Placeholder when null. */
  image?: string | null;
}

export function Voucher(props: VoucherProps): JSX.Element;

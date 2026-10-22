export interface StepperProps {
  /** Current numeric value (controlled). */
  value?: number;
  /** Minimum allowed value (clamped, not disabled). Default 0. */
  min?: number;
  /** Maximum allowed value (clamped, not disabled). Default 99. */
  max?: number;
  /** Amount added/removed per tap. Default 1. */
  step?: number;
  /** Visual size. `md` = 40px (default), `sm` = 32px (compact/inline). */
  size?: 'sm' | 'md';
  /** Called with the next clamped value. */
  onChange?: (value: number) => void;
  /** Accessible label for the group. Default "Quantity". */
  ariaLabel?: string;
}

export function Stepper(props: StepperProps): JSX.Element;

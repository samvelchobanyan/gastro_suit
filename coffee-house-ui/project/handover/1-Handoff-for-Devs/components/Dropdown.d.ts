export interface DropdownOption { label: string; value: any; }

export interface DropdownProps {
  label?: string | null;
  value?: any;
  options?: DropdownOption[];
  placeholder?: string;
  onChange?: (value: any) => void;
  error?: boolean;
  helperText?: string | null;
  disabled?: boolean;
  /** 'default' (48px) or 'floating' (56px). */
  size?: 'default' | 'floating';
}

export function Dropdown(props: DropdownProps): JSX.Element;

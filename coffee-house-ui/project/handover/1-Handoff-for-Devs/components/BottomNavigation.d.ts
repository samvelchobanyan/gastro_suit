export interface BottomNavItem {
  key: string;
  /** Phosphor icon name (filled automatically when active). */
  icon: string;
  label?: string;
  badge?: number | string;
}

export interface BottomNavigationProps {
  items?: BottomNavItem[];
  activeKey?: string;
  onChange?: (key: string) => void;
  /** Show text labels (64px) vs icons only (56px). Default true. */
  showLabels?: boolean;
}

export function BottomNavigation(props: BottomNavigationProps): JSX.Element;

import React from 'react';

/**
 * SizeSelector — tappable size option: size name on top, price below.
 * Used for product size/variant choices (menu items, add-ons).
 */
export function SizeSelector({
  name = 'Regular',
  price = '$0.00',
  selected = false,
  onClick = () => {},
}) {
  return (
    <button type="button" onClick={onClick} style={{
      display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 'var(--space-xxs)',
      flex: 1, width: '100%', padding: 'var(--space-sm) var(--space-md)', boxSizing: 'border-box',
      background: selected ? 'var(--color-brand-subtle)' : 'var(--color-bg-main)',
      border: `1px solid ${selected ? 'var(--color-brand-primary)' : 'var(--color-border-default)'}`,
      borderRadius: 'var(--radius-md)', cursor: 'pointer', fontFamily: 'var(--font-family-base)',
      WebkitTapHighlightColor: 'transparent',
    }}>
      <span style={{
        fontSize: 'var(--font-size-body-xs)', lineHeight: 'var(--line-height-body-xs)',
        fontWeight: 'var(--font-weight-semibold)',
        color: selected ? 'var(--color-text-accent)' : 'var(--color-text-primary)',
      }}>{name}</span>
      <span style={{
        fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)',
        color: selected ? 'var(--color-text-accent)' : 'var(--color-text-secondary)',
      }}>{price}</span>
    </button>
  );
}

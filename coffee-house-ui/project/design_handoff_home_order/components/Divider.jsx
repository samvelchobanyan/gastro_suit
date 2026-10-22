import React from 'react';

/**
 * Divider — thin line separating content sections or list groups.
 * Horizontal by default; supports an inset and an optional centered label.
 */
export function Divider({ inset = 0, label = null, vertical = false }) {
  if (vertical) {
    return <span aria-hidden="true" style={{ display: 'inline-block', width: 1, alignSelf: 'stretch', background: 'var(--color-border-muted)' }} />;
  }
  if (label) {
    return (
      <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-md)', margin: 'var(--space-sm) 0' }}>
        <span style={{ flex: 1, height: 1, background: 'var(--color-border-muted)' }} />
        <span style={{
          fontFamily: 'var(--font-family-base)', fontSize: 'var(--font-size-caption)',
          color: 'var(--color-text-tertiary)', fontWeight: 'var(--font-weight-semibold)',
        }}>{label}</span>
        <span style={{ flex: 1, height: 1, background: 'var(--color-border-muted)' }} />
      </div>
    );
  }
  return <hr aria-hidden="true" style={{ border: 0, height: 1, margin: 0, marginLeft: inset, background: 'var(--color-border-muted)' }} />;
}

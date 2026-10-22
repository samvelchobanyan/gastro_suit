import React from 'react';

/**
 * ScreenHeader — top-of-screen page title in Heading 1 style, with an
 * optional back button on the left and an optional action slot on the right.
 * Full-width; used at the top of a screen below the status bar.
 */
export function ScreenHeader({
  title = 'Screen title',
  onBack = null,
  action = null,
}) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 'var(--space-sm)', width: '100%',
      padding: 'var(--space-base)', background: 'var(--color-bg-surface)',
      fontFamily: 'var(--font-family-base)', boxSizing: 'border-box',
    }}>
      {onBack && (
        <button type="button" onClick={onBack} aria-label="Back" style={{
          width: 44, height: 44, marginLeft: 'calc(-1 * var(--space-sm))', flex: '0 0 auto',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          border: 'none', background: 'transparent', color: 'var(--color-text-primary)',
          cursor: 'pointer', borderRadius: 'var(--radius-full)', WebkitTapHighlightColor: 'transparent',
        }}>
          <i className="ph ph-arrow-left" aria-hidden="true" style={{ fontSize: 'var(--icon-md)' }} />
        </button>
      )}
      <h1 style={{
        flex: 1, minWidth: 0, margin: 0,
        fontSize: 'var(--font-size-h1)', lineHeight: 'var(--line-height-h1)',
        fontWeight: 'var(--font-weight-bold)', fontFamily: 'var(--font-family-base)',
        color: 'var(--color-text-primary)',
      }}>{title}</h1>
      {action && <div style={{ flex: '0 0 auto', display: 'flex', alignItems: 'center' }}>{action}</div>}
    </div>
  );
}

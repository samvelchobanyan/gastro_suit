import React from 'react';

/**
 * BottomNavigation — persistent bottom navigation between core sections.
 * 56px (no labels) to 64px (labeled). Active item uses accent + filled icon.
 */
export function BottomNavigation({
  items = [],          // [{ key, icon, label, badge }]
  activeKey = null,
  onChange = () => {},
  showLabels = true,
}) {
  const bar = {
    display: 'flex', alignItems: 'stretch',
    borderRadius: 'var(--radius-full)', overflow: 'hidden',
    height: showLabels ? 'var(--bottomnav-height-labeled)' : 'var(--bottomnav-height)',
    background: 'var(--bottomnav-bg)',
    paddingBottom: 'env(safe-area-inset-bottom, 0px)',
    fontFamily: 'var(--font-family-base)',
  };

  return (
    <nav style={bar} aria-label="Primary">
      {items.map((it) => {
        const active = it.key === activeKey;
        return (
          <button
            key={it.key} type="button" onClick={() => onChange(it.key)}
            aria-current={active ? 'page' : undefined}
            style={{
              flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center',
              justifyContent: 'center', gap: 'var(--space-xxs)', border: 'none', background: 'transparent',
              color: active ? 'var(--bottomnav-icon-active)' : 'var(--bottomnav-icon)',
              cursor: 'pointer', padding: 'var(--space-xs) 0', WebkitTapHighlightColor: 'transparent',
              transition: 'color var(--duration-fast) var(--ease-standard)',
            }}
          >
            <span style={{ position: 'relative', display: 'inline-flex' }}>
              <i className={`${active ? 'ph-fill' : 'ph'} ph-${it.icon}`} aria-hidden="true" style={{ fontSize: 'var(--icon-md)' }} />
              {it.badge != null && (
                <span style={{
                  position: 'absolute', top: -4, right: -8, minWidth: 16, height: 16, padding: '0 4px',
                  boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                  background: 'var(--badge-bg)', color: 'var(--badge-text)', borderRadius: 'var(--radius-full)',
                  fontSize: 'var(--font-size-body-xs)', fontWeight: 'var(--font-weight-bold)', lineHeight: 1,
                }}>{it.badge}</span>
              )}
            </span>
            {showLabels && (
              <span style={{
                fontSize: 'var(--font-size-body-xs)', lineHeight: 'var(--line-height-body-xs)',
                fontFamily: 'var(--font-family-base)',
              }}>{it.label}</span>
            )}
          </button>
        );
      })}
    </nav>
  );
}

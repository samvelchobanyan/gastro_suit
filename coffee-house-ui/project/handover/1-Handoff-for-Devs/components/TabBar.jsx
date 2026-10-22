import React from 'react';

/**
 * TabBar — horizontal set of tabs for switching views
 * within a single screen. Sliding accent indicator. Also used for
 * Delivery/Pickup style two-option toggles.
 */
export function TabBar({
  options = [],        // [{ label, value, icon? }] or strings
  value = null,
  onChange = () => {},
  size = 'big',        // 'big' (full-width, 40px) | 'small' (compact, auto-width) | 'xs' (compact, no icons, smaller label)
  fullWidth,
}) {
  const small = size === 'small' || size === 'xs';
  const xs = size === 'xs';
  const isFull = fullWidth != null ? fullWidth : !small;
  const norm = options.map((o) => (typeof o === 'string' ? { label: o, value: o } : o));
  const idx = Math.max(0, norm.findIndex((o) => o.value === value));

  const wrap = small ? {
    position: 'relative', display: 'inline-flex', gap: 'var(--space-sm)',
    width: isFull ? '100%' : 'auto', fontFamily: 'var(--font-family-base)',
  } : {
    position: 'relative', display: 'inline-flex', width: isFull ? '100%' : 'auto',
    padding: 'var(--space-xs)', boxSizing: 'border-box', background: 'var(--color-bg-surface-sunken)',
    borderRadius: 'var(--radius-full)', fontFamily: 'var(--font-family-base)',
  };
  const indicator = {
    position: 'absolute', top: 'var(--space-xs)', bottom: 'var(--space-xs)', left: 'var(--space-xs)',
    width: `calc((100% - (var(--space-xs) * 2)) / ${norm.length})`,
    transform: `translateX(${idx * 100}%)`,
    background: 'var(--color-bg-main)', borderRadius: 'var(--radius-full)',
    boxShadow: 'var(--elevation-card)',
    transition: 'transform var(--duration-base) var(--ease-standard)',
  };

  return (
    <div style={wrap} role="tablist">
      {!small && <span style={indicator} aria-hidden="true" />}
      {norm.map((o) => {
        const active = o.value === value;
        if (small) {
          return (
            <button
              key={String(o.value)} type="button" role="tab" aria-selected={active}
              onClick={() => onChange(o.value)}
              style={{
                display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 'var(--space-xs)',
                flex: isFull ? 1 : '0 0 auto', minHeight: 'var(--button-height-xs)', boxSizing: 'border-box', padding: '0 var(--space-md)',
                border: active ? 'var(--border-width-default) solid var(--color-brand-primary)' : 'none',
                background: active ? 'var(--gray-0)' : 'var(--gray-100)',
                color: active ? 'var(--color-text-accent)' : 'var(--gray-500)',
                borderRadius: 'var(--radius-full)',
                fontSize: xs ? 'var(--font-size-body-sm)' : 'var(--font-size-body)', lineHeight: xs ? 'var(--line-height-body-sm)' : 'var(--line-height-body)',
                fontWeight: 'var(--font-weight-semibold)',
                cursor: 'pointer', WebkitTapHighlightColor: 'transparent', whiteSpace: 'nowrap',
                transition: 'var(--transition-colors)',
              }}
            >
              {!xs && o.icon && <i className={`ph ph-${o.icon}`} aria-hidden="true" style={{ fontSize: 'var(--icon-xs)' }} />}
              {o.label}
            </button>
          );
        }
        return (
          <button
            key={String(o.value)} type="button" role="tab" aria-selected={active}
            onClick={() => onChange(o.value)}
            style={{
              position: 'relative', zIndex: 1, flex: isFull ? 1 : '0 0 auto',
              display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 'var(--space-xs)',
              minHeight: small ? 'var(--button-height-xs)' : 'var(--button-height-sm)', padding: small ? '0 var(--space-md)' : '0 var(--space-base)', border: 'none', background: 'transparent',
              color: active ? 'var(--color-text-primary)' : 'var(--color-text-tertiary)',
              fontSize: 'var(--font-size-body)', lineHeight: 'var(--line-height-body)', fontWeight: 'var(--font-weight-semibold)',
              cursor: 'pointer', WebkitTapHighlightColor: 'transparent', whiteSpace: 'nowrap',
              transition: 'color var(--duration-base) var(--ease-standard)',
            }}
          >
            {o.icon && <i className={`ph ph-${o.icon}`} aria-hidden="true" style={{ fontSize: 'var(--icon-xs)' }} />}
            {o.label}
          </button>
        );
      })}
    </div>
  );
}

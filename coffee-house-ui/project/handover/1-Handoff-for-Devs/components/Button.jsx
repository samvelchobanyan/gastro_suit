import React from 'react';

/**
 * Button — primary CTA, secondary (outline) and tertiary (text) actions.
 * Neutral/base level; brand applied via tokens. Heights follow the spec
 * button scale (56 / 48 / 40 / 32). Supports leading/trailing icons,
 * loading (frozen size + spinner) and disabled states.
 */
export function Button({
  children,
  variant = 'primary', // 'primary' | 'secondary' | 'tertiary' | 'destructive'
  size = 'md',         // 'lg' 56 | 'md' 48 | 'sm' 40 | 'xs' 32
  fullWidth = false,
  disabled = false,
  loading = false,
  iconLeft = null,     // phosphor name, e.g. 'shopping-cart-simple'
  iconRight = null,
  onClick = () => {},
  type = 'button',
  radius,              // override: 'sm' | 'md' | 'lg' | 'full'
  ariaLabel,
}) {
  const [pressed, setPressed] = React.useState(false);

  const heights = { lg: 56, md: 48, sm: 40, xs: 32 };
  const fonts = { lg: 16, md: 16, sm: 14, xs: 13 };
  const pads = { lg: 24, md: 20, sm: 16, xs: 12 };
  const h = heights[size];
  const radiusVal = radius ? `var(--radius-${radius})` : (size === 'xs' ? 'var(--radius-sm)' : 'var(--radius-md)');

  const palettes = {
    primary: {
      bg: pressed ? 'var(--button-primary-bg-active)' : 'var(--button-primary-bg)',
      color: 'var(--button-primary-text)', border: 'transparent',
    },
    secondary: {
      bg: pressed ? 'var(--button-secondary-bg-active)' : 'var(--button-secondary-bg)',
      color: 'var(--button-secondary-text)', border: 'var(--button-secondary-border)',
    },
    tertiary: {
      bg: pressed ? 'var(--button-tertiary-bg-active)' : 'transparent',
      color: 'var(--button-tertiary-text)', border: 'transparent',
    },
    destructive: {
      bg: pressed ? 'var(--red-600)' : 'var(--color-status-error)',
      color: 'var(--color-text-on-brand)', border: 'transparent',
    },
  };
  const p = palettes[variant] || palettes.primary;

  const style = {
    display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
    gap: 'var(--space-sm)', width: fullWidth ? '100%' : 'auto',
    height: h, padding: `0 ${pads[size]}px`, boxSizing: 'border-box',
    background: p.bg, color: p.color,
    border: `var(--border-width-default) solid ${p.border}`,
    borderRadius: radiusVal,
    fontFamily: 'var(--font-family-base)', fontSize: fonts[size],
    fontWeight: 'var(--font-weight-semibold)', lineHeight: 1,
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    opacity: disabled ? 'var(--state-disabled-opacity)' : 1,
    transition: 'var(--transition-press)',
    WebkitTapHighlightColor: 'transparent', position: 'relative', whiteSpace: 'nowrap',
  };

  const clear = () => setPressed(false);

  return (
    <button
      type={type} style={style} disabled={disabled || loading}
      onClick={onClick} aria-label={ariaLabel} aria-busy={loading || undefined}
      onPointerDown={() => !disabled && !loading && setPressed(true)}
      onPointerUp={clear} onPointerLeave={clear}
    >
      {loading && (
        <span
          aria-hidden="true"
          style={{
            width: 18, height: 18, borderRadius: '50%',
            border: '2px solid currentColor', borderTopColor: 'transparent',
            opacity: 0.9, animation: 'gastro-spin .7s linear infinite',
          }}
        />
      )}
      {!loading && iconLeft && <i className={`ph ph-${iconLeft}`} aria-hidden="true" style={{ fontSize: 20 }} />}
      {!loading && <span>{children}</span>}
      {!loading && iconRight && <i className={`ph ph-${iconRight}`} aria-hidden="true" style={{ fontSize: 20 }} />}
      <style>{'@keyframes gastro-spin{to{transform:rotate(360deg)}}'}</style>
    </button>
  );
}

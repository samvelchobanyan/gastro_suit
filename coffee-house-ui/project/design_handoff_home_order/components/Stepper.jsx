import React from 'react';

/**
 * Stepper — increment/decrement control for quantity selection.
 * Neutral/base level; brand applied via tokens.
 */
export function Stepper({
  value = 0,
  min = 0,
  max = 99,
  step = 1,
  size = 'md',
  onChange = () => {},
  ariaLabel = 'Quantity',
}) {
  const [pressed, setPressed] = React.useState(null); // 'dec' | 'inc' | null

  const dims = size === 'sm'
    ? { h: 'var(--button-height-xxs)', btn: 'var(--button-height-xxs)', val: 'var(--button-height-xxs)', font: 'var(--font-size-body-sm)', icon: 'var(--icon-sm)' }
    : { h: 'var(--button-height-sm)', btn: 'var(--button-height-sm)', val: 44, font: 'var(--font-size-body)', icon: 'var(--icon-md)' };

  const clamp = (v) => Math.max(min, Math.min(max, v));
  const dec = () => onChange(clamp(value - step));
  const inc = () => onChange(clamp(value + step));

  const wrap = {
    display: 'inline-flex',
    alignItems: 'center',
    height: dims.h,
    border: 'none',
    borderRadius: 'var(--radius-md)',
    background: 'var(--gray-50)',
    userSelect: 'none',
  };

  const btn = (isPressed) => ({
    width: dims.btn,
    height: dims.btn,
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    border: 'none',
    background: isPressed ? 'var(--overlay-press-dark)' : 'transparent',
    borderRadius: 'var(--radius-md)',
    color: 'var(--color-text-primary)',
    cursor: 'pointer',
    padding: 0,
    fontSize: dims.icon,
    transition: 'var(--transition-press)',
    WebkitTapHighlightColor: 'transparent',
  });

  const val = {
    minWidth: dims.val,
    textAlign: 'center',
    fontFamily: 'var(--font-family-base)',
    fontSize: dims.font,
    fontWeight: 'var(--font-weight-semibold)',
    color: 'var(--color-text-primary)',
    fontVariantNumeric: 'tabular-nums',
  };

  return (
    <div style={wrap} role="group" aria-label={ariaLabel}>
      <button
        type="button"
        style={btn(pressed === 'dec')}
        onClick={dec}
        onPointerDown={() => setPressed('dec')}
        onPointerUp={() => setPressed(null)}
        onPointerLeave={() => setPressed(null)}
        aria-label="Decrease"
      >
        <i className="ph ph-minus" aria-hidden="true" />
      </button>
      <span style={val} aria-live="polite">{value}</span>
      <button
        type="button"
        style={btn(pressed === 'inc')}
        onClick={inc}
        onPointerDown={() => setPressed('inc')}
        onPointerUp={() => setPressed(null)}
        onPointerLeave={() => setPressed(null)}
        aria-label="Increase"
      >
        <i className="ph ph-plus" aria-hidden="true" />
      </button>
    </div>
  );
}

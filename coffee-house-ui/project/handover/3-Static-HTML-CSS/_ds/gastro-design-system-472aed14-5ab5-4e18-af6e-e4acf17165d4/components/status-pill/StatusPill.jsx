import React from 'react';

/**
 * StatusPill — small text status pill for states like Open / Closed,
 * Active / Inactive, Available / Sold out. Soft tonal background with a
 * matching text color. Body Small text on a full-radius capsule.
 */
export function StatusPill({
  children,
  tone = 'success',   // 'success' | 'error' | 'warning' | 'neutral'
}) {
  const tones = {
    success: { bg: 'var(--color-bg-success)', color: 'var(--color-text-success)' },
    error:   { bg: 'var(--color-bg-error)',   color: 'var(--color-text-error)' },
    warning: { bg: 'var(--color-bg-warning)', color: 'var(--color-text-warning)' },
    neutral: { bg: 'var(--gray-100)',         color: 'var(--color-text-secondary)' },
  };
  const t = tones[tone] || tones.success;
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', padding: 'var(--space-xxs) var(--space-sm)',
      borderRadius: 'var(--radius-full)', background: t.bg, color: t.color,
      fontFamily: 'var(--font-family-base)',
      fontSize: 'var(--font-size-body-xs)', lineHeight: 'var(--line-height-body-xs)',
      fontWeight: 'var(--font-weight-bold)',
    }}>{children}</span>
  );
}

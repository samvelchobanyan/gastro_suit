import React from 'react';

/**
 * Stories — Instagram-style story ring: circular avatar/cover thumbnail with
 * a ring that indicates unseen (brand-color ring) vs seen (muted grey ring),
 * plus an optional label beneath. Compose several in a horizontal scroll row.
 */
export function Stories({
  imageUrl = null,
  label = '',
  seen = false,
  size = 64,
  onClick = () => {},
}) {
  const ring = seen ? 'var(--color-border-default)' : 'var(--color-brand-primary)';
  const pad = 2;
  const inner = size - pad * 2 - 4; // ring padding + white gap

  return (
    <button type="button" onClick={onClick} style={{
      display: 'inline-flex', flexDirection: 'column', alignItems: 'center', gap: 'var(--space-xs)',
      border: 'none', background: 'transparent', cursor: 'pointer', padding: 0,
      fontFamily: 'var(--font-family-base)', WebkitTapHighlightColor: 'transparent',
      width: size + 8,
    }}>
      <span style={{
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        width: size, height: size, borderRadius: '50%', boxSizing: 'border-box',
        padding: pad, background: ring,
      }}>
        <span style={{
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          width: '100%', height: '100%', borderRadius: '50%', boxSizing: 'border-box',
          border: '2px solid var(--color-bg-surface)', overflow: 'hidden',
          background: 'var(--color-bg-muted)',
        }}>
          {imageUrl ? (
            <img src={imageUrl} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover', borderRadius: '50%' }} />
          ) : (
            <i className="ph-fill ph-image" style={{ fontSize: inner * 0.4, color: 'var(--color-text-tertiary)' }} aria-hidden="true" />
          )}
        </span>
      </span>
      {label && (
        <span style={{
          fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)',
          color: seen ? 'var(--color-text-tertiary)' : 'var(--color-text-primary)',
          fontWeight: 'var(--font-weight-regular)', maxWidth: size + 8,
          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis', textAlign: 'center',
        }}>{label}</span>
      )}
    </button>
  );
}

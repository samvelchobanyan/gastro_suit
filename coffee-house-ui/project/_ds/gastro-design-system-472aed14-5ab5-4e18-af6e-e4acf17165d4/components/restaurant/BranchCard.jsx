import React from 'react';
import { StatusPill } from '../status-pill/StatusPill.jsx';

/**
 * BranchCard — single row/card for a restaurant's physical location:
 * photo, name, address and today's working hours. Used in a branch
 * picker/listing (choose pickup location, view all locations).
 */
export function BranchCard({
  image = null,
  name = '',
  address = '',
  hours = '',
  isOpenNow = true,
  distance = null,     // e.g. "1.2 km"
  onClick = null,
}) {
  const [pressed, setPressed] = React.useState(false);
  const interactive = Boolean(onClick);
  const Tag = interactive ? 'button' : 'div';

  return (
    <Tag
      type={interactive ? 'button' : undefined} onClick={onClick}
      onPointerDown={() => interactive && setPressed(true)}
      onPointerUp={() => setPressed(false)} onPointerLeave={() => setPressed(false)}
      style={{
        display: 'flex', alignItems: 'center', gap: 'var(--space-md)', width: '100%',
        padding: 0, boxSizing: 'border-box', textAlign: 'left',
        background: 'transparent', border: 'none',
        borderRadius: 0,
        cursor: interactive ? 'pointer' : 'default', fontFamily: 'var(--font-family-base)',
        transform: pressed ? 'scale(var(--press-scale))' : 'none', transition: 'var(--transition-press)',
      }}
    >
      <div style={{
        flex: '0 0 auto', width: 72, height: 72, borderRadius: 'var(--radius-md)', overflow: 'hidden',
        background: image ? `center/cover no-repeat url("${image}")` : 'var(--color-bg-surface-sunken)',
      }} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 'var(--space-sm)' }}>
          <span style={{
            fontSize: 'var(--font-size-body)', lineHeight: 'var(--line-height-body)', color: 'var(--color-text-primary)',
            overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
          }}>{name}</span>
          {distance && (
            <span style={{ flex: '0 0 auto', fontSize: 'var(--font-size-caption)', lineHeight: 'var(--line-height-body)', color: 'var(--color-text-tertiary)' }}>{distance}</span>
          )}
        </div>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 'var(--space-xs)', marginTop: 'var(--space-xs)',
          fontSize: 'var(--font-size-body-sm)', lineHeight: 'var(--line-height-body-sm)', color: 'var(--color-text-secondary)',
        }}>
          <i className="ph ph-map-pin" aria-hidden="true" style={{ fontSize: 'var(--icon-xs)', flex: '0 0 auto', color: 'var(--color-text-tertiary)' }} />
          <span style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{address}</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 'var(--space-xs)', marginTop: 'var(--space-xs)' }}>
          <i className="ph ph-clock" aria-hidden="true" style={{ fontSize: 'var(--icon-xs)', flex: '0 0 auto', color: 'var(--color-text-tertiary)' }} />
          <span style={{ fontSize: 'var(--font-size-body-xs)', lineHeight: 'var(--line-height-body-xs)', color: 'var(--color-text-tertiary)' }}>{hours}</span>
          <span style={{ marginLeft: 'var(--space-xs)' }}>
            <StatusPill tone={isOpenNow ? 'success' : 'error'}>{isOpenNow ? 'Open' : 'Closed'}</StatusPill>
          </span>
        </div>
      </div>
      {interactive && <i className="ph ph-caret-right" aria-hidden="true" style={{ flex: '0 0 auto', fontSize: 'var(--icon-sm)', color: 'var(--color-text-tertiary)' }} />}
    </Tag>
  );
}

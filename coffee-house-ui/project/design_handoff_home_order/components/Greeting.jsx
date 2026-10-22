import React from 'react';

/**
 * Greeting — app home header row: brand logo on the left, a two-line
 * greeting beside it ("Greetings" overline + "Hi, {name}" title), and a
 * notification bell on the right with an optional unread dot.
 * White-label: pass `logoUrl` to swap the placeholder brand mark.
 */
export function Greeting({
  name = 'there',
  greeting = 'Greetings',
  logoUrl = null,
  hasNotifications = true,
  onBellClick = () => {},
}) {
  const bell = (
    <button type="button" onClick={onBellClick} aria-label="Notifications" style={{
      position: 'relative', width: 44, height: 44, flex: '0 0 auto', borderRadius: 'var(--radius-full)',
      border: 'none', background: 'transparent', color: 'var(--color-text-primary)', cursor: 'pointer',
      display: 'flex', alignItems: 'center', justifyContent: 'center', WebkitTapHighlightColor: 'transparent',
      transition: 'var(--transition-colors)',
    }}>
      <i className="ph ph-bell" style={{ fontSize: 'var(--icon-md)' }} aria-hidden="true" />
      {hasNotifications && (
        <span aria-hidden="true" style={{
          position: 'absolute', top: 9, right: 10, width: 9, height: 9, borderRadius: '50%',
          background: 'var(--color-brand-primary)', border: '2px solid var(--color-bg-surface)',
        }} />
      )}
    </button>
  );

  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 'var(--space-md)',
      padding: 'var(--space-base)', background: 'var(--color-bg-surface)',
      fontFamily: 'var(--font-family-base)', boxSizing: 'border-box', width: '100%',
    }}>
      {/* Brand logo */}
      {logoUrl ? (
        <img src={logoUrl} alt="" style={{ width: 44, height: 44, borderRadius: 'var(--radius-md)', objectFit: 'cover', flex: '0 0 auto' }} />
      ) : (
        <div aria-hidden="true" style={{
          width: 44, height: 44, borderRadius: 'var(--radius-md)', flex: '0 0 auto',
          background: 'var(--color-brand-primary)', color: 'var(--color-text-on-brand)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <i className="ph-fill ph-fork-knife" style={{ fontSize: 'var(--icon-md)' }} />
        </div>
      )}

      {/* Greeting text */}
      <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 'var(--space-xxs)' }}>
        <span style={{
          fontSize: 'var(--font-size-caption)', lineHeight: 'var(--line-height-caption)',
          color: 'var(--color-text-tertiary)', fontWeight: 'var(--font-weight-regular)',
        }}>{greeting}</span>
        <span style={{
          fontSize: 'var(--font-size-h3)', lineHeight: 'var(--line-height-h3)',
          fontWeight: 'var(--font-weight-bold)', color: 'var(--color-text-primary)',
          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
        }}>{name}</span>
      </div>

      {bell}
    </div>
  );
}

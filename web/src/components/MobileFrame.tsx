import { ReactNode } from 'react';
import styles from './MobileFrame.module.scss';

interface Props {
  children: ReactNode;
}

export default function MobileFrame({ children }: Props) {
  return (
    <div className={styles.frame}>
      <div className={styles.screen}>{children}</div>
    </div>
  );
}

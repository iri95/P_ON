import styles from './mobile.module.css';

export default function index() {
  return (
    <div className={styles['mobile-container']}>
      <div className={`${styles.device} ${styles.note8}`}>
        <div className={styles.inner} />
        <div className={styles.overflow}>
          <div className={styles.shadow} />
        </div>
        <div className={styles.speaker} />
        <div className={styles.sleep} />
        <div className={styles.volume} />
        <div className={styles.screen}>
          <iframe title="mobileDemo" src="https://p-on.site/wanyviny" width="100%" height="100%" />
        </div>
      </div>
    </div>
  );
}

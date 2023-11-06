import styles from './Home.module.scss';

export default function Section2() {
  return (
    <div className={`${styles.section2} ${styles.service}`}>
      <div className={styles['text-container']}>
        <div className={styles.text}>기능설명</div>
      </div>
      <div className={styles['image-container']}>
        <div className={styles.image}>기능캡쳐</div>
      </div>
    </div>
  );
}

import styles from './Home.module.scss';
import GoogleBtn from './downloadBtn';

export default function Section1() {
  return (
    <div className={styles.section1}>
      <div className={styles.screenshots}>
        <div className={`${styles.screen}`}>메인1</div>
        <div className={`${styles.screen}`}>메인2</div>
        <div className={`${styles.screen}`}>메인3</div>
      </div>

      <div className={styles.text}>
        <p className={styles.title}>P:ON 슬로건</p>
        <p className={styles.description}>한 줄 임팩트 있는 설명</p>
        <GoogleBtn />
      </div>
    </div>
  );
}

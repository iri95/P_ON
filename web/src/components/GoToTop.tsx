'use client';

import { useEffect, useState } from 'react';
import { BiArrowToTop } from 'react-icons/bi';
import styles from './GoToTop.module.scss';

export default function GoToTop() {
  const [toggleBtn, setToggleBtn] = useState(true);

  const handleScroll = () => {
    const { scrollY } = window;
    scrollY > 200 ? setToggleBtn(true) : setToggleBtn(false); // eslint-disable-line
  };

  useEffect(() => {
    window.addEventListener('scroll', handleScroll);

    return () => {
      window.removeEventListener('scroll', handleScroll);
    };
  }, []);

  const goTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return toggleBtn ? (
    <button className={styles.button} type="button" onClick={goTop}>
      <BiArrowToTop color="white" size={48} />
    </button>
  ) : null;
}

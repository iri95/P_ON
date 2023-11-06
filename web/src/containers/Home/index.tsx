'use client';

import { useRef } from 'react';
import { motion, useScroll, useTransform, MotionValue, AnimatePresence } from 'framer-motion';
import Image from 'next/Image';
import styles from './Home.module.scss';
import Section1 from './Section1';
import SectionEnd from './SectionEnd';

function useParallax(value: MotionValue<number>, distance: number) {
  return useTransform(value, [0, 1], [-distance, distance]);
}

export default function Index() {
  const serviceFunction = [
    {
      id: 1,
      tag: '약속',
      image_alt: ['약속방 화면', '약속 생성 화면'],
      image_scr: ['약속방 화면', '약속 생성 화면'],
      title: '손쉬운 약속 생성 및 관리',
      description: ['약속방을 간편하게 확인할 수 있어요', '세부 정보를 입력해 약속을 구체화 할 수 있어요'],
    },
    {
      id: 2,
      tag: '소통',
      image_alt: ['약속방 채팅 화면', '투표 화면'],
      image_scr: ['약속방 채팅 화면', '투표 화면'],
      title: '손쉬운 약속 생성 및 관리',
      description: ['약속방을 간편하게 확인할 수 있어요', '세부 정보를 입력해 약속을 구체화 할 수 있어요'],
    },
    {
      id: 3,
      tag: '추억',
      image_alt: ['추억 탭 화면', '하나 누른 상세 화면'],
      image_scr: ['추억 탭 화면', '하나 누른 상세 화면'],
      title: '과거의 약속을 회상해요',
      description: ['종료된 약속을 모아서 관리할 수 있어요', '소중한 추억을 다시 한 번 떠올려보세요'],
    },
    {
      id: 4,
      tag: '챗봇 - 핑키',
      image_alt: ['챗봇 대화 화면 1', '챗봇 대화 화면 2'],
      image_scr: ['챗봇 대화 화면 1', '챗봇 대화 화면 2'],
      title: '일정을 간편하게 확인할 수 있어요',
      description: ['챗봇 핑키에게 원하는 날짜의 일정을 조회할 수 있어요', '약속에 대한 정보를 확인할 수 있어요'],
    },
    {
      id: 5,
      tag: '일정',
      image_alt: ['내 일정 화면', '친구 일정 화면'],
      image_scr: ['내 일정 화면', '친구 일정 화면'],
      title: '개인 일정을 관리하고 중요한 날짜를 기록해요',
      description: ['특정 날짜와 시간에 일정을 추가하고 편집할 수 있어요', '다른 친구의 일정 여부도 확인해보세요'],
    },
  ];

  const ref = useRef(null);
  const { scrollYProgress } = useScroll({ target: ref });
  const y = useParallax(scrollYProgress, 300);

  return (
    <AnimatePresence>
      <div className={`${styles.scroll}`}>
        <div className={styles.section}>
          <Section1 />
        </div>

        {serviceFunction.map((service) => (
          <section
            key={service.id}
            className={`${styles.section} ${styles.section2} ${styles.service}`}
            id={`section${service.id}`}
          >
            <motion.div className={styles['text-container']} style={{ y }}>
              소개
            </motion.div>
            <div className={styles['image-container']} ref={ref}>
              <div className={styles.screen}>{/* <Image /> */}</div>
            </div>
          </section>
        ))}

        <SectionEnd />
        <div className={`${styles.section} ${styles.lastSection}`} />
      </div>
    </AnimatePresence>
  );
}
